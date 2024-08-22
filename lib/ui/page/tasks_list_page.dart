import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/task.dart';
import 'package:flutter_todo/ui/widgets/task_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../data/repository/movie_repository_impl.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {

  late final MovieRepositoryImpl moviesRepo;
  late final PagingController<int, Task> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    moviesRepo = Provider.of<MovieRepositoryImpl>(context, listen: false);
    _pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          final tasks = await moviesRepo.getTasks(page: pageKey, limit: 10);

          _pagingController.appendPage(tasks, null);
//          _pagingController.appendPage(tasks, pageKey + 1);
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
          title: Text("Tasks"),
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        body: PagedListView<int, Task>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Task>(
            itemBuilder: (context, task, index) => TaskCard(task: task),
          ),
        )
    );
  }
}
