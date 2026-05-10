part of 'tasks_bloc.dart';

// <<EVENTS>>
final class SyncPendingQueueStarted extends TasksEvent {
  const SyncPendingQueueStarted();

  @override
  List<Object?> get props => const [];
}

final class ResolveConflictStartedStarted extends TasksEvent {
  const ResolveConflictStartedStarted(this.task, this.useServer);

  final UpdateTaskRequest task;
  final bool useServer;

  @override
  List<Object?> get props => [task, useServer];
}

final class UpdateTaskStarted extends TasksEvent {
  const UpdateTaskStarted(this.request);

  final UpdateTaskRequest request;

  @override
  List<Object?> get props => [request];
}

final class GetTasksStarted extends TasksEvent {
  const GetTasksStarted();

  @override
  List<Object?> get props => const [];
}

final class WatchSyncStatusStarted extends TasksEvent {
  const WatchSyncStatusStarted();

  @override
  List<Object?> get props => const [];
}

abstract base class TasksEvent extends Equatable {
  const TasksEvent();
}
