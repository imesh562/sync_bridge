import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:sync_bridge/error/exceptions.dart';
import 'package:sync_bridge/error/failures.dart';
import 'package:sync_bridge/features/tasks/data/datasources/tasks_local_datasource.dart';
import 'package:sync_bridge/features/tasks/data/datasources/tasks_remote_datasource.dart';
import 'package:sync_bridge/features/tasks/data/models/update_task_request.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/features/tasks/domain/repositories/tasks_repository.dart';

@LazySingleton(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl(this._remote, this._local, this._connectivity);

  final TasksRemoteDatasource _remote;
  final TasksLocalDatasource _local;
  final Connectivity _connectivity;

  Future<bool> get _isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  @override
  Future<Either<Failure, Stream<List<TaskEntity>>>> getTasks() async {
    try {
      final isCacheEmpty = await _local.isEmpty();
      if (await _isOnline && isCacheEmpty) {
        final response = await _remote.getTasks();
        await _local.seedTasks(response.tasks);
      }

      return Right(_local.watchTasks());
    } on UnAuthorizedException catch (e) {
      return Left(UnAuthorizedFailure(e.message));
    } on ForceUpdateException catch (e) {
      return Left(ForceUpdateFailure(e.message));
    } on MaintenanceException catch (e) {
      return Left(MaintenanceFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(UpdateTaskRequest request) async {
    try {
      final isOnline = await _isOnline;
      final snapshot = await _local.getTaskSnapshot(request.id!);

      await _local.updateTaskLocally(request, !isOnline, !isOnline);

      if (isOnline) {
        try {
          await _remote.updateTask(request);
        } catch (_) {
          await _local.restoreSnapshot(request.id!, snapshot);
          rethrow;
        }
      }

      return const Right(null);
    } on UnAuthorizedException catch (e) {
      return Left(UnAuthorizedFailure(e.message));
    } on ForceUpdateException catch (e) {
      return Left(ForceUpdateFailure(e.message));
    } on MaintenanceException catch (e) {
      return Left(MaintenanceFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message, e.task));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncPendingQueue() async {
    try {
      final queue = await _local.getPendingQueue();

      if (queue.isEmpty) return const Right(null);

      for (final pending in queue) {
        final request = UpdateTaskRequest.fromJson(
          jsonDecode(pending.payload!) as Map<String, dynamic>,
        );
        try {
          await _remote.updateTask(request);
          await _local.markSynced(pending.taskId!, pending.id!);
        } on ConflictException catch (e) {
          await _local.markConflict(pending.taskId!);
        }
      }

      return const Right(null);
    } on UnAuthorizedException catch (e) {
      return Left(UnAuthorizedFailure(e.message));
    } on ForceUpdateException catch (e) {
      return Left(ForceUpdateFailure(e.message));
    } on MaintenanceException catch (e) {
      return Left(MaintenanceFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resolveConflict(
    UpdateTaskRequest payload,
    bool useServer,
  ) async {
    try {
      await _local.resolveConflict(payload: payload, useServer: useServer);

      return const Right(null);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<SyncLogEntity> watchSyncStatus() => _remote.watchSyncStatus();
}
