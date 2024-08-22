import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(
                left: 8,
                top: 8,
                right: 8,
                bottom: 8,
              ),
              child: Column(
                children: [
                  Text(
                    "${task.title} a",
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    task.description,
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
