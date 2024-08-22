import 'package:flutter_todo/domain/movie.dart';
import 'package:flutter_todo/domain/task.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies({ required int page, required int limit});
  Future<List<Task>> getTasks({ required int page, required int limit});
}