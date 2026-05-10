import 'package:equatable/equatable.dart';

final class SyncLogEntity extends Equatable {
  const SyncLogEntity({
    required this.status,
    required this.message,
    required this.timestamp,
  });

  final String status;
  final String message;
  final DateTime timestamp;

  @override
  List<Object?> get props => [status, message, timestamp];
}
