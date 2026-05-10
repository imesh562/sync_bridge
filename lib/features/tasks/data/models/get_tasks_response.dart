import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_tasks_response.g.dart';

@JsonSerializable()
final class GetTasksResponse extends Equatable {
  const GetTasksResponse({this.tasks = const []});

  factory GetTasksResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTasksResponseFromJson(json);

  final List<TaskItem> tasks;

  Map<String, dynamic> toJson() => _$GetTasksResponseToJson(this);

  @override
  List<Object?> get props => [tasks];
}

@JsonSerializable()
final class TaskItem extends Equatable {
  const TaskItem({this.userId, this.id, this.title, this.completed});

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  @override
  List<Object?> get props => [userId, id, title, completed];
}
