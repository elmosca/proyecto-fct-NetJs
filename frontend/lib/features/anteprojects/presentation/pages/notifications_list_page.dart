import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart'
    as app_notification;
import 'package:fct_frontend/features/anteprojects/presentation/providers/notification_providers.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/notification_card_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/notification_filters_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsListPage extends ConsumerStatefulWidget {
  const NotificationsListPage({super.key});

  @override
  ConsumerState<NotificationsListPage> createState() =>
      _NotificationsListPageState();
}

class _NotificationsListPageState extends ConsumerState<NotificationsListPage> {
  @override
  void initState() {
    super.initState();
    // Cargar notificaciones al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filters = ref.read(notificationFiltersNotifierProvider);
      ref
          .read(notificationsNotifierProvider.notifier)
          .loadNotifications(filters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsNotifierProvider);
    final filters = ref.watch(notificationFiltersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(notificationsNotifierProvider.notifier)
                  .loadNotifications(filters);
            },
          ),
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              _showMarkAllAsReadDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          NotificationFiltersWidget(
            onFiltersChanged: (newFilters) {
              ref
                  .read(notificationFiltersNotifierProvider.notifier)
                  .updateFilters(newFilters);
              ref
                  .read(notificationsNotifierProvider.notifier)
                  .loadNotifications(newFilters);
            },
          ),
          Expanded(
            child: notificationsState.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No hay notificaciones',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref
                        .read(notificationsNotifierProvider.notifier)
                        .loadNotifications(filters);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: NotificationCardWidget(
                          notification: notification,
                          onTap: () => _onNotificationTap(notification),
                          onMarkAsRead: () => _onMarkAsRead(notification),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar notificaciones: $error',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(notificationsNotifierProvider.notifier)
                            .loadNotifications(filters);
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNotificationTap(app_notification.Notification notification) {
    // Navegar al detalle de la notificación
    // TODO: Implementar navegación al detalle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notificación: ${notification.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onMarkAsRead(app_notification.Notification notification) {
    ref
        .read(notificationsNotifierProvider.notifier)
        .markAsRead(notification.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notificación marcada como leída'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMarkAllAsReadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar todas como leídas'),
        content: const Text(
            '¿Estás seguro de que quieres marcar todas las notificaciones como leídas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Obtener userId del usuario actual
              const userId = 'current_user_id';
              ref
                  .read(notificationsNotifierProvider.notifier)
                  .markAllAsRead(userId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Todas las notificaciones marcadas como leídas'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
