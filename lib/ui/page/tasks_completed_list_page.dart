import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/task.dart';
import 'package:flutter_todo/ui/widgets/task_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../data/repository/task_repository_impl.dart';

class TasksCompletedListPage extends StatefulWidget {
  final String title;

  const TasksCompletedListPage({
    super.key,
    required this.title,
  });

  @override
  State<TasksCompletedListPage> createState() => _TasksCompletedListPageState();
}

class _TasksCompletedListPageState extends State<TasksCompletedListPage> {
  late final TaskRepositoryImpl taskRepository;
  late final PagingController<int, Task> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    taskRepository = Provider.of<TaskRepositoryImpl>(context, listen: false);
    _pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          final tasks = await taskRepository.getTasks(
              page: pageKey, limit: 10, isCompleted: true);
          _pagingController.appendPage(tasks.data, tasks.next);
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

  Future<void> _showDeleteConfirmation(BuildContext context, Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Tarefa'),
          content:
              const Text('Você tem certeza que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await taskRepository.deleteTask(id: task.id as String);
      setState(() {
        _pagingController.itemList?.remove(task);
      });
    }
  }

  Future<void> _handleReopenTask(Task task) async {
    final updatedTask = task.copyWith(isCompleted: false);
    await taskRepository.updateTask(task: updatedTask);
    setState(() {
      _pagingController.itemList?.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Column(
        children: [
          Expanded(
            child: PagedListView<int, Task>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Task>(
                itemBuilder: (context, task, index) => TaskCard(
                  task: task,
                  onLongPress: () => _showDeleteConfirmation(context, task),
                  leftWidget: Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _handleReopenTask(task),
                      child: Container(
                        height: 100,
                        color: Theme.of(context).colorScheme.secondary,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
