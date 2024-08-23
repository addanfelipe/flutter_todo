import 'package:flutter_todo/data/api/api_client.dart';
import 'package:flutter_todo/data/database/app_database.dart';
import 'package:flutter_todo/data/database/task_entity.dart';
import 'package:flutter_todo/data/repository/task_repository.dart';
import 'package:flutter_todo/domain/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final ApiClient apiClient;
  final AppDatabase database;

  TaskRepositoryImpl({required this.apiClient, required this.database});

  Future<List<Task>> getTasks({required int page, required int limit}) async {
    try {
      final tasks = await apiClient.getTasks(page: page, limit: limit);

      await database.taskDao.deleteAllTasks();

      await database.taskDao.insertTasks(tasks
          .map<TaskEntity>((Task task) => TaskEntity.fromTask(task))
          .toList());

      return tasks;
    } catch (e) {
      final ts = await database.taskDao.findAll();
      final tasks = ts.map<Task>((TaskEntity task) => task.toTask()).toList();

      return tasks;
    }
  }
}
