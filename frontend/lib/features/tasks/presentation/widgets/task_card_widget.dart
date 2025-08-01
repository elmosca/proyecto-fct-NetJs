import 'package:flutter/material.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';

class TaskCardWidget extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final Function(TaskStatus)? onStatusChanged;

  const TaskCardWidget({
    super.key,
    required this.task,
    this.onTap,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y estado
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Descripción
              if (task.description.isNotEmpty) ...[
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              
              // Información adicional
              Row(
                children: [
                  // Prioridad
                  _buildPriorityChip(),
                  const SizedBox(width: 8),
                  
                  // Fecha de vencimiento
                  if (task.dueDate != null) ...[
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: _isOverdue(task.dueDate!) 
                          ? Colors.red 
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(task.dueDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: _isOverdue(task.dueDate!) 
                            ? Colors.red 
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  // Horas estimadas
                  if (task.estimatedHours != null) ...[
                    Icon(Icons.timer, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${task.estimatedHours}h',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
              
              // Tags
              if (task.tags != null && task.tags!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: task.tags!.map((tag) => Chip(
                    label: Text(
                      tag,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.grey[200],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(task.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(task.status),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.status.icon,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            task.status.displayName,
            style: TextStyle(
              fontSize: 10,
              color: _getStatusColor(task.status),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getPriorityColor(task.priority).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.priority.icon,
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(width: 2),
          Text(
            task.priority.displayName,
            style: TextStyle(
              fontSize: 10,
              color: _getPriorityColor(task.priority),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.review:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference < 0) {
      return 'Vencida';
    } else if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Mañana';
    } else if (difference < 7) {
      return 'En $difference días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 