import 'package:injectable/injectable.dart';
import 'package:sync_bridge/core/network/api_helper.dart';
import 'package:sync_bridge/features/tasks/data/services/sync_status_service.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';

import '../models/get_tasks_response.dart';
import '../models/update_task_request.dart';
import '../models/update_task_response.dart';

@lazySingleton
class TasksRemoteDatasource {
  TasksRemoteDatasource(this._api, this._syncStatus);

  final ApiHelper _api;
  final SyncStatusService _syncStatus;

  Future<GetTasksResponse> getTasks() async {
    final response = await _api.get<List<dynamic>>('todos');
    final tasks =
        (response.data ?? [])
            .map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
            .toList();
    return GetTasksResponse(tasks: tasks);
  }

  Future<UpdateTaskResponse> updateTask(UpdateTaskRequest request) async {
    final response = await _api.put<Map<String, dynamic>>(
      'todos/${request.id}',
      data: request.toJson(),
    );
    return UpdateTaskResponse.fromJson(response.data!);
  }

  Stream<SyncLogEntity> watchSyncStatus() => _syncStatus.watch();
}
