import 'package:equatable/equatable.dart';

final class TaskEntity extends Equatable {
  const TaskEntity({
    this.id,
    this.userId,
    this.title,
    this.completed,
    this.updatedAt,
    this.isDirty,
    this.isConflict,
  });

  final int? id;
  final int? userId;
  final String? title;
  final int? completed;
  final int? updatedAt;
  final int? isDirty;
  final int? isConflict;

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      title: map['title'] as String?,
      completed: map['completed'] as int?,
      updatedAt: map['updated_at'] as int?,
      isDirty: map['is_dirty'] as int?,
      isConflict: map['is_conflict'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'completed': completed,
      'updated_at': updatedAt,
      'is_dirty': isDirty,
      'is_conflict': isConflict,
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    completed,
    updatedAt,
    isDirty,
    isConflict,
  ];
}
