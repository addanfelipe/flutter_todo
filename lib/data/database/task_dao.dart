import 'package:floor/floor.dart';
import 'package:flutter_todo/data/database/task_entity.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM tasks WHERE isCompleted = :isCompleted')
  Future<List<TaskEntity>> findTasks(bool isCompleted);

  @insert
  Future<void> insertTask(TaskEntity task);

  @insert
  Future<void> insertTasks(List<TaskEntity> tasks);

  @Query('DELETE FROM tasks WHERE isCompleted = :isCompleted')
  Future<void> deleteTasks(bool isCompleted);

  @Query('DELETE FROM tasks WHERE id = :id')
  Future<void> deleteTask(String id);

  @update
  Future<void> updateTask(TaskEntity task);
}
