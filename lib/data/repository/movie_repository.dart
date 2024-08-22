import 'package:flutter_todo/domain/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies({ required int page, required int limit});
}