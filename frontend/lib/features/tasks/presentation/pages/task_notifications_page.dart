import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/entities/task_notification_entity.dart';
import '../providers/task_notification_providers.dart';
import '../widgets/task_notification_card.dart';

class TaskNotificationsPage extends ConsumerStatefulWidget {
  const TaskNotificationsPage({super.key});

  @override
  ConsumerState<TaskNotificationsPage> createState() =>
      _TaskNotificationsPageState();
}

class _TaskNotificationsPageState extends ConsumerState<TaskNotificationsPage> {
  TaskNotificationFiltersDto _filters = const TaskNotificationFiltersDto();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    final notifier = ref.read(taskNotificationsNotifierProvider.notifier);
    await notifier.loadNotifications(_filters);
  }

  Future<void> _refreshNotifications() async {
    final notifier = ref.read(taskNotificationsNotifierProvider.notifier);
    await notifier.refresh(_filters);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(taskNotificationsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskNotificationsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFiltersDialog,
            tooltip: l10n.filter,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: notificationsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.notifications_none,
                title: l10n.noNotificationsTitle,
                message: l10n.noNotificationsMessage,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TaskNotificationCard(
                    notification: notification,
                    onTap: () => _onNotificationTap(notification),
                    onMarkAsRead: () => _markAsRead(notification.id),
                    onDelete: () => _deleteNotification(notification.id),
                  ),
                );
              },
            );
          },
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.errorLoadingNotifications,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadNotifications,
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _markAllAsRead,
        tooltip: l10n.markAllAsRead,
        child: const Icon(Icons.mark_email_read),
      ),
    );
  }

  void _onNotificationTap(TaskNotification notification) {
    // TODO: Implementar navegación a la tarea o proyecto relacionado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando a: ${notification.title}'),
      ),
    );
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      final notifier = ref.read(taskNotificationsNotifierProvider.notifier);
      await notifier.markAsRead(notificationId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.notificationMarkedAsRead),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteNotification),
        content:
            Text(AppLocalizations.of(context)!.deleteNotificationConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final notifier = ref.read(taskNotificationsNotifierProvider.notifier);
        await notifier.deleteNotification(notificationId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.notificationDeleted),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final notificationsAsync = ref.read(taskNotificationsNotifierProvider);
    final notifications = notificationsAsync.value;

    if (notifications == null || notifications.isEmpty) return;

    final unreadNotifications = notifications
        .where((n) => n.status == TaskNotificationStatus.unread)
        .map((n) => n.id)
        .toList();

    if (unreadNotifications.isEmpty) return;

    try {
      final notifier = ref.read(taskNotificationsNotifierProvider.notifier);
      await notifier.markMultipleAsRead(unreadNotifications);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.allNotificationsMarkedAsRead),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => _NotificationFiltersDialog(
        filters: _filters,
        onApply: (filters) {
          setState(() {
            _filters = filters;
          });
          _loadNotifications();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _NotificationFiltersDialog extends StatefulWidget {
  final TaskNotificationFiltersDto filters;
  final Function(TaskNotificationFiltersDto) onApply;

  const _NotificationFiltersDialog({
    required this.filters,
    required this.onApply,
  });

  @override
  State<_NotificationFiltersDialog> createState() =>
      _NotificationFiltersDialogState();
}

class _NotificationFiltersDialogState
    extends State<_NotificationFiltersDialog> {
  late TaskNotificationFiltersDto _filters;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.filterNotifications),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text(l10n.unreadOnly),
              value: _filters.unreadOnly ?? false,
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(unreadOnly: value);
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskNotificationType?>(
              decoration: InputDecoration(
                labelText: l10n.notificationType,
                border: const OutlineInputBorder(),
              ),
              value: _filters.type,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.allTypes),
                ),
                ...TaskNotificationType.values.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(type: value);
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onApply(_filters);
            }
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
