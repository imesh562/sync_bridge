import 'package:equatable/equatable.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class AppFailure extends Failure {
  const AppFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure(super.message);
}

final class ForceUpdateFailure extends Failure {
  const ForceUpdateFailure(super.message);
}

final class MaintenanceFailure extends Failure {
  const MaintenanceFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class ConflictFailure extends Failure {
  final TaskEntity task;
  const ConflictFailure(super.message, this.task);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
