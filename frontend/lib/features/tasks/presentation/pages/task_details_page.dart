import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/assign_users_dialog.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/edit_task_dialog.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TaskDetailsPage extends ConsumerWidget {
  final Task task;

  const TaskDetailsPage({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskDetails),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditDialog(context, task);
                  break;
                case 'delete':
                  _showDeleteDialog(context, task, ref);
                  break;
              }
            },
            itemBuilder: (context) => [
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
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      l10n.delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildTaskDetails(context, task, l10n),
    );
  }

  Widget _buildTaskDetails(
      BuildContext context, Task task, AppLocalizations l10n) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y estado
          _buildHeader(context, task, l10n),
          const SizedBox(height: 24),

          // Información básica
          _buildBasicInfo(context, task, l10n, dateFormat),
          const SizedBox(height: 24),

          // Descripción
          _buildDescription(context, task, l10n),
          const SizedBox(height: 24),

          // Metadatos
          _buildMetadata(context, task, l10n, dateFormat),
          const SizedBox(height: 24),

          // Etiquetas
          if (task.tags.isNotEmpty) ...[
            _buildTags(context, task, l10n),
            const SizedBox(height: 24),
          ],

          // Asignados
          if (task.assignees.isNotEmpty) ...[
            _buildAssignees(context, task, l10n),
            const SizedBox(height: 24),
          ],

          // Usuarios asignados (nueva sección)
          _buildAssignedUsers(context, task, l10n),
          const SizedBox(height: 24),

          // Acciones
          _buildActions(context, task, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, Task task, AppLocalizations l10n) {
    return Card(
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildStatusChip(context, task.status, l10n),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPriorityChip(context, task.priority, l10n),
                const SizedBox(width: 8),
                _buildComplexityChip(context, task.complexity, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context, Task task,
      AppLocalizations l10n, DateFormat dateFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.basicInformation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                context, l10n.status, _getStatusText(task.status, l10n)),
            _buildInfoRow(
                context, l10n.priority, _getPriorityText(task.priority, l10n)),
            _buildInfoRow(context, l10n.complexity,
                _getComplexityText(task.complexity, l10n)),
            if (task.estimatedHours != null)
              _buildInfoRow(
                  context, l10n.estimatedHours, '${task.estimatedHours} horas'),
            if (task.dueDate != null)
              _buildInfoRow(
                  context, l10n.dueDate, dateFormat.format(task.dueDate!)),
            _buildInfoRow(
                context, l10n.createdAt, dateFormat.format(task.createdAt)),
            _buildInfoRow(
                context,
                l10n.updatedAt,
                task.updatedAt != null
                    ? dateFormat.format(task.updatedAt!)
                    : 'No actualizado'),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(
      BuildContext context, Task task, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, Task task,
      AppLocalizations l10n, DateFormat dateFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.metadata,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, 'ID', task.id),
            _buildInfoRow(context, l10n.project, task.projectId),
            if (task.milestoneId != null)
              _buildInfoRow(context, l10n.milestones, task.milestoneId!),
            _buildInfoRow(
                context, l10n.createdAt, dateFormat.format(task.createdAt)),
            _buildInfoRow(
                context,
                l10n.updatedAt,
                task.updatedAt != null
                    ? dateFormat.format(task.updatedAt!)
                    : 'No actualizado'),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(
      BuildContext context, Task task, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.tags,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: task.tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignees(
      BuildContext context, Task task, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.assignees,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: task.assignees
                  .map((assignee) => Chip(
                        avatar: const Icon(Icons.person, size: 16),
                        label: Text(assignee),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(
      BuildContext context, Task task, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.actions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditDialog(context, task),
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.edit),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _changeStatus(context, task),
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(l10n.changeStatus),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteDialog(context, task, null),
                icon: const Icon(Icons.delete),
                label: Text(l10n.delete),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedUsers(
      BuildContext context, Task task, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.assignedUsers,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showAssignUsersDialog(context, task),
                  icon: const Icon(Icons.person_add),
                  tooltip: l10n.assignUsers,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (task.assignees.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    l10n.noUsersAssigned,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: task.assignees.map((assigneeId) {
                  return Chip(
                    label: Text(
                        assigneeId), // TODO: Obtener nombre real del usuario
                    avatar: CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        assigneeId.isNotEmpty
                            ? assigneeId[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    deleteIcon:
                        const Icon(Icons.remove_circle_outline, size: 16),
                    onDeleted: () => _unassignUser(task.id, assigneeId),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context, TaskStatus status, AppLocalizations l10n) {
    Color color;
    switch (status) {
      case TaskStatus.pending:
        color = Colors.orange;
        break;
      case TaskStatus.inProgress:
        color = Colors.blue;
        break;
      case TaskStatus.completed:
        color = Colors.green;
        break;
      case TaskStatus.underReview:
        color = Colors.orange;
        break;
      case TaskStatus.cancelled:
        color = Colors.grey;
        break;
    }

    return Chip(
      label: Text(
        _getStatusText(status, l10n),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildPriorityChip(
      BuildContext context, TaskPriority priority, AppLocalizations l10n) {
    Color color;
    switch (priority) {
      case TaskPriority.low:
        color = Colors.green;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        break;
      case TaskPriority.high:
        color = Colors.red;
        break;
      case TaskPriority.critical:
        color = Colors.purple;
        break;
    }

    return Chip(
      label: Text(
        _getPriorityText(priority, l10n),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildComplexityChip(
      BuildContext context, TaskComplexity complexity, AppLocalizations l10n) {
    Color color;
    switch (complexity) {
      case TaskComplexity.simple:
        color = Colors.green;
        break;
      case TaskComplexity.medium:
        color = Colors.orange;
        break;
      case TaskComplexity.complex:
        color = Colors.red;
        break;
    }

    return Chip(
      label: Text(
        _getComplexityText(complexity, l10n),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  String _getStatusText(TaskStatus status, AppLocalizations l10n) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.completed:
        return 'Completada';
      case TaskStatus.underReview:
        return 'En Revisión';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  String _getPriorityText(TaskPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.critical:
        return 'Crítica';
    }
  }

  String _getComplexityText(TaskComplexity complexity, AppLocalizations l10n) {
    switch (complexity) {
      case TaskComplexity.simple:
        return 'Simple';
      case TaskComplexity.medium:
        return 'Media';
      case TaskComplexity.complex:
        return 'Compleja';
    }
  }

  void _showEditDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );
  }

  void _showDeleteDialog(
      BuildContext context, Task task, WidgetRef? ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTask),
        content: Text(l10n.deleteTaskConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (ref != null) {
                // TODO: [REVIEW_NEEDED] - Revisar configuración de TasksNotifierFamily
                // ref.read(tasksNotifierProvider.notifier).deleteTask(task.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Tarea eliminada temporalmente')),
                );
              }
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _changeStatus(BuildContext context, Task task) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskStatus.values.map((status) {
            return ListTile(
              title: Text(_getStatusText(status, l10n)),
              leading: Radio<TaskStatus>(
                value: status,
                groupValue: task.status,
                onChanged: (value) {
                  if (value != null) {
                    Navigator.of(context).pop();
                    // TODO: Implementar cambio de estado
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Estado cambiado a: ${_getStatusText(value, l10n)}')),
                    );
                  }
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showAssignUsersDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AssignUsersDialog(task: task),
    );
  }

  void _unassignUser(String taskId, String userId) {
    // TODO: Implementar desasignación real
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Usuario desasignado: $userId')),
    // );
  }
}
