import 'package:flutter_todo/data/database/dao/movie_dao.dart';
import 'package:flutter_todo/data/database/database_mapper.dart';
import 'package:flutter_todo/data/network/client/api_client.dart';
import 'package:flutter_todo/data/network/network_mapper.dart';
import 'package:flutter_todo/data/repository/movie_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {

    final api_client = ApiClient(baseUrl: "http://192.168.0.21:3000");
    final network_mapper = NetworkMapper();
    final database_mapper = DatabaseMapper();
    final movie_dao = MovieDao();

    final movies_repository = MovieRepositoryImpl(
        apiClient: api_client,
        networkMapper: network_mapper,
        databaseMapper: database_mapper,
        movieDao: movie_dao
    );

    return ConfigureProviders(providers: [
      Provider<ApiClient>.value(value: api_client),
      Provider<NetworkMapper>.value(value: network_mapper),
      Provider<DatabaseMapper>.value(value: database_mapper),
      Provider<MovieDao>.value(value: movie_dao),
      Provider<MovieRepositoryImpl>.value(value: movies_repository),
    ]);
  }
}


