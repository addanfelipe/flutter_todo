import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/movie.dart';
import 'package:flutter_todo/ui/widgets/movie_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../data/repository/movie_repository_impl.dart';

class MoviesListPage extends StatefulWidget {
  const MoviesListPage({super.key});

  @override
  State<MoviesListPage> createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {

  late final MovieRepositoryImpl moviesRepo;
  late final PagingController<int, Movie> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    moviesRepo = Provider.of<MovieRepositoryImpl>(context, listen: false);
    _pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          final movies = await moviesRepo.getMovies(page: pageKey, limit: 10);
          _pagingController.appendPage(movies, pageKey + 1);
        } catch (e) {
          _pagingController.error = e;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        body: PagedListView<int, Movie>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Movie>(
            itemBuilder: (context, movie, index) => MovieCard(movie: movie),
          ),
        )

        /*
      body: FutureBuilder(
          future: moviesRepo.getMovies(page: 1, limit: 10),
          builder: (context, snapshop) {
            if (snapshop.hasData) {
              return ListView(
                children: List.generate(
                  snapshop.data!.length,
                  (index) => MovieCard(movie: snapshop.data![index]),
                ),
              );
            } else {
              return LinearProgressIndicator();
            }
          }),*/
        );

    /*
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
      ),
      body: FutureBuilder(
          future: moviesRepo.getMovies(),
          builder: (context, snapshop) {
            if (snapshop.hasData) {
              return ListView(
                children: List.generate(
                    snapshop.data!.length,
                    (index) => ListTile(
                          title: Text(snapshop.data![index].title),
                        )),
              );
            } else {
              return LinearProgressIndicator();
            }
          }),
    );
     */
  }
}
