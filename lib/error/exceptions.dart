import 'package:dio/dio.dart' as dio;
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';

abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Returned for 4xx/5xx server responses not covered by more specific types.
final class ServerException extends AppException {
  const ServerException(super.message);
}

/// Returned for 401, 403, and 407 responses.
final class UnAuthorizedException extends AppException {
  const UnAuthorizedException(super.message);
}

/// Returned for 426 — the client must update before proceeding.
final class ForceUpdateException extends AppException {
  const ForceUpdateException(super.message);
}

/// Returned for 503 — the service is temporarily unavailable.
final class MaintenanceException extends AppException {
  const MaintenanceException(super.message);
}

/// Returned for network-level failures (no HTTP status code available).
final class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Returned for server side data conflictions.
final class ConflictException extends AppException {
  final TaskEntity task;
  const ConflictException(super.message, this.task);
}

AppException mapHttpError(dio.DioException error) {
  final statusCode = error.response?.statusCode;
  final body = error.response?.data;
  final serverMessage = body is Map ? body['message'] as String? : null;

  return switch (statusCode) {
    401 || 403 || 407 => UnAuthorizedException(serverMessage ?? 'Unauthorized'),
    409 => ConflictException(
      serverMessage ?? 'Data conflict on server',
      TaskEntity.fromMap({
        ...body as Map<String, dynamic>,
        'completed': ((body['completed'] as bool?) ?? false) ? 1 : 0,
      }),
    ),
    426 => ForceUpdateException(serverMessage ?? 'App update required'),
    503 => MaintenanceException(serverMessage ?? 'Service under maintenance'),
    _ when statusCode != null => ServerException(
      serverMessage ?? 'Server error: $statusCode',
    ),
    _ => NetworkException(error.message ?? 'Network error'),
  };
}
