import 'package:flutter_todo/data/database/dao/movie_dao.dart';
import 'package:flutter_todo/data/database/database_mapper.dart';
import 'package:flutter_todo/data/network/client/api_client.dart';
import 'package:flutter_todo/data/network/network_mapper.dart';
import 'package:flutter_todo/data/repository/movie_repository.dart';
import 'package:flutter_todo/domain/task.dart';

import '../../domain/movie.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final MovieDao movieDao;
  final DatabaseMapper databaseMapper;

  MovieRepositoryImpl(
      {required this.movieDao,
      required this.databaseMapper,
      required this.apiClient,
      required this.networkMapper});

  Future<List<Movie>> getMovies({ required int page, required int limit}) async {
    //Tentar carregar a partir do banco de dados
    final dbEntities = await movieDao.selectAll(limit: 10, offset: (page * limit) - limit);
    //Se o dado já existe, carregar esse dado.
    if (dbEntities.isNotEmpty) {
      return databaseMapper.toMovies(dbEntities);
    }
    //Caso contrário, buscar pela API remota
    final networkEntity = await apiClient.getMovies(page: page, limit: limit);
    final movies = networkMapper.toMovies(networkEntity);
    //E salvar os dados no banco local para cash
    movieDao.insertAll(databaseMapper.toMovieDatabaseEntities(movies));

    return movies;
  }

  Future<List<Task>> getTasks({ required int page, required int limit}) async {
    final tasks = await apiClient.getTasks(page: page, limit: limit);
    return tasks;
  }
}
