import 'package:flutter_todo/domain/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({required int page, required int limit});
}
