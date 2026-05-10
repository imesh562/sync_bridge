import 'package:json_annotation/json_annotation.dart';

part 'update_task_request.g.dart';

@JsonSerializable(explicitToJson: true)
final class UpdateTaskRequest {
  const UpdateTaskRequest({this.userId, this.id, this.title, this.completed});

  factory UpdateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskRequestFromJson(json);

  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

  Map<String, dynamic> toJson() => _$UpdateTaskRequestToJson(this);
}
