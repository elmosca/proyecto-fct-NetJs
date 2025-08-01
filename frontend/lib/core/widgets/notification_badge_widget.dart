import 'package:fct_frontend/features/dashboard/presentation/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Función auxiliar para formatear fechas
String _formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 0) {
    return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
  } else if (difference.inHours > 0) {
    return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
  } else if (difference.inMinutes > 0) {
    return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
  } else {
    return 'Ahora mismo';
  }
}

/// Widget que muestra un badge con el número de notificaciones no leídas
class NotificationBadgeWidget extends ConsumerStatefulWidget {
  const NotificationBadgeWidget({super.key});

  @override
  ConsumerState<NotificationBadgeWidget> createState() =>
      _NotificationBadgeWidgetState();
}

class _NotificationBadgeWidgetState
    extends ConsumerState<NotificationBadgeWidget> {
  @override
  void initState() {
    super.initState();
    // Cargar notificaciones al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationStateProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationStateProvider);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: _showNotificationDialog,
          tooltip: 'Notificaciones',
        ),
        if (notificationState.unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                notificationState.unreadCount > 99
                    ? '99+'
                    : notificationState.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) => const NotificationDialog(),
    );
  }
}

/// Dialog que muestra la lista de notificaciones
class NotificationDialog extends ConsumerWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationStateProvider);
    final notificationNotifier = ref.read(notificationStateProvider.notifier);

    return Dialog(
      child: Container(
        width: 400,
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notificaciones',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    if (notificationState.unreadCount > 0)
                      TextButton(
                        onPressed: () {
                          notificationNotifier.markAllAsRead();
                        },
                        child: const Text('Marcar todas como leídas'),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: notificationState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notificationState.notifications.isEmpty
                      ? _buildEmptyState()
                      : _buildNotificationList(
                          notificationState, notificationNotifier),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No hay notificaciones',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
    dynamic notificationState,
    dynamic notificationNotifier,
  ) {
    return ListView.builder(
      itemCount: notificationState.notifications.length,
      itemBuilder: (context, index) {
        final notification = notificationState.notifications[index];
        return _buildNotificationItem(notification, notificationNotifier);
      },
    );
  }

  Widget _buildNotificationItem(
    dynamic notification,
    dynamic notificationNotifier,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: notification.isRead ? null : Colors.blue.withOpacity(0.1),
      child: ListTile(
        leading: _getNotificationIcon(notification.type),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatDate(notification.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            if (!notification.isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: Text('Marcar como leída'),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar'),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'mark_read':
                notificationNotifier.markAsRead(notification.id);
                break;
              case 'delete':
                notificationNotifier.deleteNotification(notification.id);
                break;
            }
          },
        ),
        onTap: () {
          if (!notification.isRead) {
            notificationNotifier.markAsRead(notification.id);
          }
          // TODO: Navegar a la pantalla correspondiente según el tipo
          // Navigator.of(context).pop(); // Comentado temporalmente
        },
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'project':
        iconData = Icons.folder;
        iconColor = Colors.blue;
        break;
      case 'task':
        iconData = Icons.task;
        iconColor = Colors.green;
        break;
      case 'user':
        iconData = Icons.person;
        iconColor = Colors.orange;
        break;
      case 'system':
        iconData = Icons.info;
        iconColor = Colors.grey;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.blue;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }
}
