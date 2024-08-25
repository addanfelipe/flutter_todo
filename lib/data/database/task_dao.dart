import 'package:floor/floor.dart';
import 'package:flutter_todo/data/database/task_entity.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM tasks')
  Future<List<TaskEntity>> findAll();

  @Query('SELECT title FROM tasks')
  Stream<List<String>> findAllTaskTitle();

  @Query('SELECT * FROM tasks WHERE id = :id')
  Stream<TaskEntity?> findTaskByid(String id);

  @insert
  Future<void> insertTask(TaskEntity task);

  @insert
  Future<void> insertTasks(List<TaskEntity> tasks);

  @Query('DELETE FROM tasks')
  Future<void> deleteAllTasks();
}
