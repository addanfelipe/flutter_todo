import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:flutter_todo/data/database/task_entity.dart';
import 'package:flutter_todo/data/database/task_dao.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [TaskEntity])
abstract class AppDatabase extends FloorDatabase {
  TaskDao get taskDao;
}
