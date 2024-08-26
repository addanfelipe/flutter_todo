import 'package:flutter_todo/data/api/api_client.dart';
import 'package:flutter_todo/data/database/app_database.dart';
import 'package:flutter_todo/data/repository/task_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {

    final api_client = ApiClient(baseUrl: "http://192.168.13.75:3000");
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    final task_repository = TaskRepositoryImpl(
        apiClient: api_client,
        database: database
    );

    return ConfigureProviders(providers: [
      Provider<ApiClient>.value(value: api_client),
      Provider<TaskRepositoryImpl>.value(value: task_repository),
      Provider<AppDatabase>.value(value: database),
    ]);
  }
}


