import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/task.dart';
import 'package:flutter_todo/ui/widgets/task_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../data/repository/task_repository_impl.dart';

class TasksOpenedListPage extends StatefulWidget {
  final String title;

  const TasksOpenedListPage({
    super.key,
    required this.title,
  });

  @override
  State<TasksOpenedListPage> createState() => _TasksOpenedListPageState();
}

class _TasksOpenedListPageState extends State<TasksOpenedListPage> {
  late final TaskRepositoryImpl taskRepository;
  late final PagingController<int, Task> _pagingController =
      PagingController(firstPageKey: 1);

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleTaskCreateFocusNode = FocusNode();
  bool _isCreatingTask = false;

  @override
  void initState() {
    super.initState();
    taskRepository = Provider.of<TaskRepositoryImpl>(context, listen: false);
    _pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          final tasks = await taskRepository.getTasks(
              page: pageKey, limit: 10, isCompleted: false);
          _pagingController.appendPage(tasks.data, tasks.next);
        } catch (e) {
          _pagingController.error = e;
        }
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleTaskCreateFocusNode.dispose();
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

  Future<void> _handleCompletedTask(Task task) async {
//    await taskRepository.updateTask(task.id);
    setState(() {
      _pagingController.itemList?.remove(task);
    });
  }

  Future<void> _handleCreateTask() async {
    setState(() {
      _isCreatingTask = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      _titleTaskCreateFocusNode.requestFocus();
    });
  }

  void _handleCreateTaskCancel() {
    setState(() {
      _isCreatingTask = false;
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  Future<void> _handleCreateTaskConfirm() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      final newTask =
          Task(title: title, description: description, isCompleted: false);
      final task = await taskRepository.createTask(task: newTask);

      setState(() {
        _isCreatingTask = false;
        _titleController.clear();
        _descriptionController.clear();
        _pagingController.itemList?.insert(0, task);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Column(
        children: [
          if (_isCreatingTask)
            TaskCard(
              isEditing: true,
              titleController: _titleController,
              descriptionController: _descriptionController,
              leftWidget: Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _handleCreateTaskCancel,
                  child: Container(
                    height: 140,
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Center(
                      child: Icon(
                        Icons.cancel,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ),
              ),
              rightWidget: Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _handleCreateTaskConfirm,
                  child: Container(
                    height: 140,
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Icon(
                        Icons.task_alt,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              titleFocusNode: _titleTaskCreateFocusNode,
            ),
          Expanded(
            child: PagedListView<int, Task>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Task>(
                itemBuilder: (context, task, index) => TaskCard(
                  task: task,
                  onLongPress: () => _showDeleteConfirmation(context, task),
                  rightWidget: Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _handleCompletedTask(task),
                      child: Container(
                        height: 100,
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.onPrimary,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _handleCreateTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
