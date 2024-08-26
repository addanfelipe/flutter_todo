import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/task.dart';

class TaskCard extends StatelessWidget {
  final Task? task;
  final bool isEditing;
  final TextEditingController? titleController;
  final TextEditingController? descriptionController;
  final FocusNode? titleFocusNode;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final VoidCallback? onLongPress;

  const TaskCard({
    super.key,
    this.task,
    this.isEditing = false,
    this.titleController,
    this.descriptionController,
    this.titleFocusNode,
    this.leftWidget,
    this.rightWidget,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        color: theme.colorScheme.primaryContainer, // cor de fundo do Card
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            // Borda Esquerda (opcional)
            if (leftWidget != null) leftWidget!,
            // Conteúdo do Card
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: isEditing
                              ? TextField(
                                  controller: titleController,
                                  focusNode: titleFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Título',
                                    border: InputBorder.none,
                                  ),
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                )
                              : Text(
                                  task?.title ?? '',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    isEditing
                        ? TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: 'Descrição',
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            style: textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                              height: 1.5,
                            ),
                          )
                        : Text(
                            task?.description ?? '',
                            style: textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                  ],
                ),
              ),
            ),
            // Borda Direita (opcional)
            if (rightWidget != null) rightWidget!,
          ],
        ),
      ),
    );
  }
}
