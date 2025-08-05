import 'package:flutter/material.dart';

import '../../domain/entities/task_notification_entity.dart';

class TaskNotificationCard extends StatelessWidget {
  final TaskNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const TaskNotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = notification.status == TaskNotificationStatus.pending;

    return Card(
      elevation: isUnread ? 2 : 1,
      color:
          isUnread ? theme.colorScheme.primaryContainer.withOpacity(0.1) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getNotificationIcon(),
                    color: _getNotificationColor(theme),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notification.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(notification.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (notification.status == TaskNotificationStatus.read)
                    Text(
                      'Leída',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
              if (onMarkAsRead != null || onDelete != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isUnread && onMarkAsRead != null)
                      TextButton.icon(
                        onPressed: onMarkAsRead,
                        icon: const Icon(Icons.mark_email_read, size: 16),
                        label: const Text('Marcar como leída'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                        ),
                      ),
                    if (onDelete != null) ...[
                      if (isUnread && onMarkAsRead != null)
                        const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Eliminar'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case TaskNotificationType.taskAssigned:
        return Icons.assignment_ind;
      case TaskNotificationType.taskStatusChanged:
        return Icons.update;
      case TaskNotificationType.taskDueDateReminder:
        return Icons.schedule;
      case TaskNotificationType.taskOverdue:
        return Icons.warning;
      case TaskNotificationType.taskCompleted:
        return Icons.check_circle;
      case TaskNotificationType.taskDependencyCompleted:
        return Icons.link;
      case TaskNotificationType.taskCommentAdded:
        return Icons.comment;
      case TaskNotificationType.taskPriorityChanged:
        return Icons.priority_high;
      case TaskNotificationType.taskMilestoneReached:
        return Icons.flag;
      case TaskNotificationType.taskGeneral:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(ThemeData theme) {
    switch (notification.type) {
      case TaskNotificationType.taskAssigned:
        return theme.colorScheme.primary;
      case TaskNotificationType.taskStatusChanged:
        return theme.colorScheme.secondary;
      case TaskNotificationType.taskDueDateReminder:
        return Colors.orange;
      case TaskNotificationType.taskOverdue:
        return theme.colorScheme.error;
      case TaskNotificationType.taskCompleted:
        return Colors.green;
      case TaskNotificationType.taskDependencyCompleted:
        return Colors.blue;
      case TaskNotificationType.taskCommentAdded:
        return Colors.purple;
      case TaskNotificationType.taskPriorityChanged:
        return Colors.red;
      case TaskNotificationType.taskMilestoneReached:
        return Colors.teal;
      case TaskNotificationType.taskGeneral:
        return theme.colorScheme.primary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora';
    }
  }
}
