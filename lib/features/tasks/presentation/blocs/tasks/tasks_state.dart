part of 'tasks_bloc.dart';

// <<STATES>>
final class SyncPendingQueueSuccess extends TasksState {
  const SyncPendingQueueSuccess();

  @override
  List<Object?> get props => const [];
}

final class SyncPendingQueueFailure extends TasksState with FailureState {
  const SyncPendingQueueFailure(this.failure);

  @override
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class ResolveConflictStartedSuccess extends TasksState {
  const ResolveConflictStartedSuccess();

  @override
  List<Object?> get props => const [];
}

final class ResolveConflictStartedFailure extends TasksState with FailureState {
  const ResolveConflictStartedFailure(this.failure);

  @override
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class UpdateTaskSuccess extends TasksState {
  @override
  List<Object?> get props => [];
}

final class UpdateTaskConflict extends TasksState {
  UpdateTaskConflict(this.task);

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

final class UpdateTaskFailure extends TasksState with FailureState {
  const UpdateTaskFailure(this.failure);

  @override
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class GetTasksSuccess extends TasksState {
  const GetTasksSuccess(this.stream);

  final Stream<List<TaskEntity>> stream;

  @override
  List<Object?> get props => [stream];
}

final class GetTasksFailure extends TasksState with FailureState {
  const GetTasksFailure(this.failure);

  @override
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

abstract base class TasksState extends Equatable {
  const TasksState();
}

final class TasksInitial extends TasksState {
  const TasksInitial();

  @override
  List<Object?> get props => const [];
}

/// Single shared loading state for this BLoC.
/// Emitted by every REST endpoint handler before the API call.
/// [BaseViewMixin] detects [AppLoadingState] and shows the loading overlay.
final class TasksLoading extends TasksState with AppLoadingState {
  const TasksLoading();

  @override
  List<Object?> get props => const [];
}

final class SyncStatusUpdate extends TasksState {
  const SyncStatusUpdate(this.log);

  final SyncLogEntity log;

  @override
  List<Object?> get props => [log];
}

final class SyncStatusFailure extends TasksState with FailureState {
  const SyncStatusFailure(this.failure);

  @override
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
