import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart'
    as app_notification;
import 'package:flutter/material.dart';

class NotificationCardWidget extends StatelessWidget {
  final app_notification.Notification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    notification.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: notification.status.isRead
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.type.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.status.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: notification.status.isRead
                      ? Colors.grey[600]
                      : Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        notification.status.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(notification.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (onMarkAsRead != null &&
                          !notification.status.isRead) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.mark_email_read, size: 16),
                          onPressed: onMarkAsRead,
                          tooltip: 'Marcar como leída',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

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

  Color _getStatusColor(app_notification.NotificationStatus status) {
    switch (status) {
      case app_notification.NotificationStatus.pending:
        return Colors.orange;
      case app_notification.NotificationStatus.sent:
        return Colors.blue;
      case app_notification.NotificationStatus.read:
        return Colors.grey;
      case app_notification.NotificationStatus.failed:
        return Colors.red;
    }
  }
}
