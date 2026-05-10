import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sync_bridge/features/tasks/data/models/get_tasks_response.dart';
import 'package:sync_bridge/features/tasks/data/models/update_task_request.dart';
import 'package:sync_bridge/features/tasks/data/services/sql_lite_service.dart';
import 'package:sync_bridge/features/tasks/domain/entities/offline_queue_entity.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/utils/app_constants.dart';

@lazySingleton
class TasksLocalDatasource {
  TasksLocalDatasource(this._sqliteService) {
    _instance = this;
  }

  final SQLiteService _sqliteService;
  static TasksLocalDatasource? _instance;

  final _taskStreamController = StreamController<List<TaskEntity>>.broadcast();

  Stream<List<TaskEntity>> watchTasks() {
    _pushUpdate();
    return _taskStreamController.stream;
  }

  Future<void> _pushUpdate() async {
    final db = await _sqliteService.database;
    final rows = await db.query('tasks', orderBy: 'id ASC');
    final tasks = rows.map(TaskEntity.fromMap).toList();
    if (!_taskStreamController.isClosed) {
      _taskStreamController.add(tasks);
    }
  }

  Future<void> seedTasks(List<TaskItem> apiTasks) async {
    final db = await _sqliteService.database;
    final batch = db.batch();
    final now = DateTime.now().millisecondsSinceEpoch;

    for (final task in apiTasks) {
      batch.insert('tasks', {
        'id': task.id,
        'user_id': task.userId,
        'title': task.title,
        'completed': (task.completed ?? false) ? 1 : 0,
        'updated_at': now,
        'is_dirty': 0,
        'is_conflict': 0,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    await batch.commit(noResult: true);
    await _pushUpdate();
  }

  Future<void> updateTaskLocally(
    UpdateTaskRequest payload,
    bool addToQueue,
    bool isDirty,
  ) async {
    final db = await _sqliteService.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      await txn.update(
        'tasks',
        {
          'completed': payload.completed! ? 1 : 0,
          'updated_at': now,
          'is_dirty': isDirty ? 1 : 0,
          'is_conflict': 0,
        },
        where: 'id = ?',
        whereArgs: [payload.id],
      );
      if (addToQueue) {
        await txn.insert('offline_queue', {
          'task_id': payload.id,
          'payload': jsonEncode(payload),
          'created_at': now,
        });
      }
    });

    await _pushUpdate();
  }

  Future<void> markSynced(int taskId, int queueId) async {
    final db = await _sqliteService.database;

    await db.transaction((txn) async {
      await txn.update(
        'tasks',
        {'is_dirty': 0},
        where: 'id = ?',
        whereArgs: [taskId],
      );
      await txn.delete('offline_queue', where: 'id = ?', whereArgs: [queueId]);
    });

    await _pushUpdate();
  }

  Future<void> markConflict(int taskId) async {
    final db = await _sqliteService.database;
    await db.update(
      'tasks',
      {'is_conflict': 1},
      where: 'id = ?',
      whereArgs: [taskId],
    );
    await _pushUpdate();
  }

  Future<void> resolveConflict({
    required UpdateTaskRequest payload,
    required bool useServer,
  }) async {
    final db = await _sqliteService.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      if (useServer) {
        await txn.update(
          'tasks',
          {
            'completed': payload.completed! ? 1 : 0,
            'updated_at': now,
            'is_dirty': 0,
            'is_conflict': 0,
          },
          where: 'id = ?',
          whereArgs: [payload.id],
        );
        await txn.delete(
          'offline_queue',
          where: 'task_id = ?',
          whereArgs: [payload.id],
        );
      } else {
        await txn.update(
          'tasks',
          {
            'is_conflict': 1,
            'is_dirty': 1,
            'updated_at': now,
            'completed': payload.completed! ? 1 : 0,
          },
          where: 'id = ?',
          whereArgs: [payload.id],
        );
        await txn.insert('offline_queue', {
          'task_id': payload.id,
          'payload': jsonEncode(payload),
          'created_at': now,
        });
      }
    });

    await _pushUpdate();
  }

  Future<List<OfflineQueueEntity>> getPendingQueue() async {
    final db = await _sqliteService.database;
    final rows = await db.query('offline_queue', orderBy: 'created_at ASC');
    return rows.map(OfflineQueueEntity.fromMap).toList();
  }

  Future<bool> isEmpty() async {
    final db = await _sqliteService.database;
    final rows = await db.query('tasks', limit: 1);
    return rows.isEmpty;
  }

  static Future<void> updateFromFcm(Map<String, dynamic> payload) async {
    final path = join(await getDatabasesPath(), AppConstants.dbSchemaName);
    final db = await openDatabase(path);
    try {
      final taskId = int.parse(payload['task_id'] as String);
      final completed = payload['completed'] == 'true';

      final existing = await db.query(
        'tasks',
        columns: ['is_dirty'],
        where: 'id = ?',
        whereArgs: [taskId],
      );

      if (existing.isEmpty) return;

      final isDirty = existing.first['is_dirty'] == 1;

      await db.update(
        'tasks',
        isDirty
            ? {'is_conflict': 1}
            : {
              'completed': completed ? 1 : 0,
              'updated_at': DateTime.now().millisecondsSinceEpoch,
              'is_dirty': 0,
              'is_conflict': 0,
            },
        where: 'id = ?',
        whereArgs: [taskId],
      );

      await _instance?._pushUpdate();
    } finally {
      await db.close();
    }
  }

  Future<TaskSnapshot> getTaskSnapshot(int taskId) async {
    final db = await _sqliteService.database;

    final taskRows = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
    final queueRows = await db.query(
      'offline_queue',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );

    return TaskSnapshot(
      task:
          taskRows.isNotEmpty
              ? Map<String, dynamic>.from(taskRows.first)
              : null,
      queueEntry:
          queueRows.isNotEmpty
              ? Map<String, dynamic>.from(queueRows.first)
              : null,
    );
  }

  Future<void> restoreSnapshot(int taskId, TaskSnapshot snapshot) async {
    final db = await _sqliteService.database;

    await db.transaction((txn) async {
      if (snapshot.task != null) {
        await txn.update(
          'tasks',
          snapshot.task!,
          where: 'id = ?',
          whereArgs: [taskId],
        );
      }

      await txn.delete(
        'offline_queue',
        where: 'task_id = ?',
        whereArgs: [taskId],
      );

      if (snapshot.queueEntry != null) {
        await txn.insert('offline_queue', snapshot.queueEntry!..remove('id'));
      }
    });

    await _pushUpdate();
  }

  Future<void> clearAll() async {
    final db = await _sqliteService.database;
    await db.transaction((txn) async {
      await txn.delete('tasks');
      await txn.delete('offline_queue');
    });
    await _pushUpdate();
  }

  Future<void> dispose() async {
    await _taskStreamController.close();
  }
}

class TaskSnapshot {
  const TaskSnapshot({this.task, this.queueEntry});

  final Map<String, dynamic>? task;
  final Map<String, dynamic>? queueEntry;
}
