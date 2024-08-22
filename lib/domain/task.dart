import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  String title;
  String description;

  Task({
    required this.title,
    required this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

// Método para serializar um objeto Task em JSON
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  String toString() {
    return 'Task{title: $title, description: $description}';
  }
}