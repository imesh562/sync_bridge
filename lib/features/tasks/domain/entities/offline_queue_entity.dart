import 'package:equatable/equatable.dart';

final class OfflineQueueEntity extends Equatable {
  const OfflineQueueEntity({
    this.id,
    this.taskId,
    this.method,
    this.payload,
    this.createdAt,
  });

  final int? id;
  final int? taskId;
  final String? method;
  final String? payload;
  final int? createdAt;

  factory OfflineQueueEntity.fromMap(Map<String, dynamic> map) {
    return OfflineQueueEntity(
      id: map['id'] as int?,
      taskId: map['task_id'] as int?,
      method: map['method'] as String?,
      payload: map['payload'] as String?,
      createdAt: map['created_at'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'task_id': taskId,
      'method': method,
      'payload': payload,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, taskId, method, payload, createdAt];
}
