import 'package:flutter_todo/data/api/api_client.dart';
import 'package:flutter_todo/data/database/app_database.dart';
import 'package:flutter_todo/data/database/task_entity.dart';
import 'package:flutter_todo/data/repository/task_repository.dart';
import 'package:flutter_todo/domain/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final ApiClient apiClient;
  final AppDatabase database;

  TaskRepositoryImpl({required this.apiClient, required this.database});

  @override
  Future<GetTasksResult> getTasks(
      {required int page, required int limit, required bool isCompleted}) async {
    try {
      final tasks = await apiClient.getTasks(page: page, limit: limit, isCompleted: isCompleted);

      await database.taskDao.deleteAllTasks();

      await database.taskDao.insertTasks(tasks.data
          .map<TaskEntity>((Task task) => TaskEntity.fromTask(task))
          .toList());

      return GetTasksResult(
          first: tasks.first,
          prev: tasks.prev,
          next: tasks.next,
          last: tasks.last,
          pages: tasks.pages,
          items: tasks.items,
          data: tasks.data);
    } catch (e) {
      final ts = await database.taskDao.findAll();
      final tasks = ts.map<Task>((TaskEntity task) => task.toTask()).toList();

      return GetTasksResult(
          first: 1,
          prev: null,
          next: null,
          last: 1,
          pages: 1,
          items: tasks.length,
          data: tasks);
    }
  }

  @override
  Future<Task> createTask({required Task task}) async {
    final newTask = await apiClient.createTask(task: task);
    database.taskDao.insertTask(TaskEntity.fromTask(newTask));
    return newTask;
  }

  @override
  Future<void> deleteTask({required String id}) async {
    await apiClient.deleteTask(id: id);
    database.taskDao.deleteTask(id);
  }

  @override
  Future<void> updateTask({required Task task}) async {
    await apiClient.updateTask(task: task);
    database.taskDao.updateTask(TaskEntity.fromTask(task));
  }
}
