import 'package:flutter_todo/domain/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasks_http_responses.g.dart';

@JsonSerializable()
class TasksPagedHttpResponse {
  int first;
  int? prev;
  int? next;
  int last;
  int pages;
  int items;
  List<Task> data;

  TasksPagedHttpResponse({
    required this.first,
    required this.prev,
    required this.next,
    required this.last,
    required this.pages,
    required this.items,
    required this.data,
  });

  factory TasksPagedHttpResponse.fromJson(Map<String, dynamic> json) =>
      _$TasksPagedHttpResponseFromJson(json);
}
