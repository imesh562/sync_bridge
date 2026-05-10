// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_tasks_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTasksResponse _$GetTasksResponseFromJson(Map<String, dynamic> json) =>
    GetTasksResponse(
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GetTasksResponseToJson(GetTasksResponse instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
    };

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => TaskItem(
      userId: (json['userId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$TaskItemToJson(TaskItem instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
    };
