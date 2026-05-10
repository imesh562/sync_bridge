import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sync_bridge/error/failures.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:sync_bridge/shared/blocs/base_states.dart';

import '../../../data/models/update_task_request.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

@injectable
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(this._repository) : super(const TasksInitial()) {
    // <<HANDLERS>>
    on<SyncPendingQueueStarted>(_onSyncPendingQueue);
    on<ResolveConflictStartedStarted>(_onResolveConflictStarted);
    on<UpdateTaskStarted>(_onUpdateTask);
    on<GetTasksStarted>(_onGetTasks);
    on<WatchSyncStatusStarted>(_onWatchSyncStatus);
  }

  final TasksRepository _repository;

  Future<void> _onGetTasks(
    GetTasksStarted event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    final result = await _repository.getTasks();
    result.fold(
      (failure) => emit(GetTasksFailure(failure)),
      (data) => emit(GetTasksSuccess(data)),
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskStarted event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _repository.updateTask(event.request);
    result.fold(
      (failure) =>
          failure is ConflictFailure
              ? emit(UpdateTaskConflict(failure.task))
              : emit(UpdateTaskFailure(failure)),
      (data) => emit(UpdateTaskSuccess()),
    );
  }

  Future<void> _onResolveConflictStarted(
    ResolveConflictStartedStarted event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    final result = await _repository.resolveConflict(
      event.task,
      event.useServer,
    );
    result.fold(
      (failure) => emit(ResolveConflictStartedFailure(failure)),
      (data) => emit(const ResolveConflictStartedSuccess()),
    );
  }

  Future<void> _onWatchSyncStatus(
    WatchSyncStatusStarted event,
    Emitter<TasksState> emit,
  ) => emit.onEach(
    _repository.watchSyncStatus(),
    onData: (log) => emit(SyncStatusUpdate(log)),
    onError: (error, _) => emit(SyncStatusFailure(AppFailure('$error'))),
  );

  Future<void> _onSyncPendingQueue(
    SyncPendingQueueStarted event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    final result = await _repository.syncPendingQueue();
    result.fold(
      (failure) => emit(SyncPendingQueueFailure(failure)),
      (data) => emit(const SyncPendingQueueSuccess()),
    );
  }
}
