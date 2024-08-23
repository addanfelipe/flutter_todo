// Classe de entidade separada para o Floor
import 'package:floor/floor.dart';
import 'package:flutter_todo/domain/task.dart';

@Entity(tableName: 'tasks')
class TaskEntity {
  @primaryKey
  final String title;
  final String description;

  TaskEntity({
    required this.title,
    required this.description,
  });

  Task toTask() => Task(title: title, description: description);

  factory TaskEntity.fromTask(Task task) => TaskEntity(
        title: task.title,
        description: task.description,
      );
}
