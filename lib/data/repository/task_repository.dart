import 'package:flutter_todo/domain/task.dart';

import 'package:json_annotation/json_annotation.dart';

part 'task_repository.g.dart';

@JsonSerializable()
class GetTasksResult {
  int first;
  int? prev;
  int? next;
  int last;
  int pages;
  int items;
  List<Task> data;

  GetTasksResult({
    required this.first,
    required this.prev,
    required this.next,
    required this.last,
    required this.pages,
    required this.items,
    required this.data,
  });

  factory GetTasksResult.fromJson(Map<String, dynamic> json) =>
      _$GetTasksResultFromJson(json);
}

abstract class TaskRepository {
  Future<GetTasksResult> getTasks({required int page, required int limit, required bool isCompleted});
  Future<Task> createTask({required Task task});
  Future<void> deleteTask({required String id});
  Future<void> updateTask({required Task task});
}
