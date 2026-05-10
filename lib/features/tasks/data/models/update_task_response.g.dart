// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTaskResponse _$UpdateTaskResponseFromJson(Map<String, dynamic> json) =>
    UpdateTaskResponse(
      userId: (json['userId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$UpdateTaskResponseToJson(UpdateTaskResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
    };
