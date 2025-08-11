import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAssignUsers;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onAssignUsers,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                        case 'assign':
                          onAssignUsers?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit, size: 16),
                              const SizedBox(width: 8),
                              Text(l10n.edit),
                            ],
                          ),
                        ),
                      if (onAssignUsers != null)
                        PopupMenuItem(
                          value: 'assign',
                          child: Row(
                            children: [
                              const Icon(Icons.person_add, size: 16),
                              const SizedBox(width: 8),
                              Text(l10n.assignUsers),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, size: 16),
                              const SizedBox(width: 8),
                              Text(l10n.delete),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatusChip(context),
                  const SizedBox(width: 8),
                  _buildPriorityChip(context),
                ],
              ),
              if (task.assignees.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${task.assignees.length} ${task.assignees.length == 1 ? 'asignado' : 'asignados'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
              if (task.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Vence: ${_formatDate(task.dueDate!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: task.isOverdue ? Colors.red : null,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Chip(
      label: Text(
        task.status.displayName,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: task.status.color.withOpacity(0.2),
      labelStyle: TextStyle(color: task.status.color),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildPriorityChip(BuildContext context) {
    return Chip(
      label: Text(
        task.priority.displayName,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: task.priority.color.withOpacity(0.2),
      labelStyle: TextStyle(color: task.priority.color),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
