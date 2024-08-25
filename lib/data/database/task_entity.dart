// Classe de entidade separada para o Floor
import 'package:floor/floor.dart';
import 'package:flutter_todo/domain/task.dart';

@Entity(tableName: 'tasks')
class TaskEntity {
  @primaryKey
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  Task toTask() => Task(id: id, title: title, description: description, isCompleted: isCompleted);

  factory TaskEntity.fromTask(Task task) => TaskEntity(
        id: task.id as String,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
      );
}
