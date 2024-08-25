// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTasksResult _$GetTasksResultFromJson(Map<String, dynamic> json) =>
    GetTasksResult(
      first: (json['first'] as num).toInt(),
      prev: (json['prev'] as num?)?.toInt(),
      next: (json['next'] as num?)?.toInt(),
      last: (json['last'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
      items: (json['items'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetTasksResultToJson(GetTasksResult instance) =>
    <String, dynamic>{
      'first': instance.first,
      'prev': instance.prev,
      'next': instance.next,
      'last': instance.last,
      'pages': instance.pages,
      'items': instance.items,
      'data': instance.data,
    };
