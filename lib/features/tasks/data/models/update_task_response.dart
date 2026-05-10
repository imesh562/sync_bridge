import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_task_response.g.dart';

@JsonSerializable()
final class UpdateTaskResponse extends Equatable {
  const UpdateTaskResponse({this.userId, this.id, this.title, this.completed});

  factory UpdateTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskResponseFromJson(json);

  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

  @override
  List<Object?> get props => [userId, id, title, completed];
}
