import 'package:fpdart/fpdart.dart';
import 'package:sync_bridge/error/failures.dart';
import 'package:sync_bridge/features/tasks/data/models/update_task_request.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';

abstract class TasksRepository {
  Future<Either<Failure, Stream<List<TaskEntity>>>> getTasks();

  Future<Either<Failure, void>> updateTask(UpdateTaskRequest request);

  Future<Either<Failure, void>> syncPendingQueue();

  Future<Either<Failure, void>> resolveConflict(
    UpdateTaskRequest payload,
    bool useServer,
  );

  Stream<SyncLogEntity> watchSyncStatus();
}
