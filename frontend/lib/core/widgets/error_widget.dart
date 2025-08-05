import 'package:flutter/material.dart';
import 'package:fct_frontend/core/extensions/color_extensions.dart';

class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.title = 'Error',
    this.onRetry,
    this.showIcon = true,
    this.icon = Icons.error_outline,
  });

  final String message;
  final String title;
  final VoidCallback? onRetry;
  final bool showIcon;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showIcon) ...[
                Icon(
                  icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ],
          ),
        ),
      );
}

/// Widget de error para listas vacías
class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
    this.title = 'No hay elementos',
    this.message = 'No se encontraron elementos para mostrar.',
    this.icon = Icons.inbox_outlined,
    this.onRefresh,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRefresh;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.color
                          ?.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.6),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onRefresh != null)
                    OutlinedButton.icon(
                      onPressed: onRefresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Actualizar'),
                    ),
                  if (onRefresh != null && onAction != null)
                    const SizedBox(width: 12),
                  if (onAction != null && actionLabel != null)
                    ElevatedButton.icon(
                      onPressed: onAction,
                      icon: const Icon(Icons.add),
                      label: Text(actionLabel!),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}

/// Widget de error para pantallas completas
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.message,
    this.title = 'Algo salió mal',
    this.onRetry,
    this.onBack,
  });

  final String message;
  final String title;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: onBack != null
            ? AppBar(
                title: const Text('Error'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                ),
              )
            : null,
        body: ErrorDisplayWidget(
          title: title,
          message: message,
          onRetry: onRetry,
        ),
      );
}

/// Widget de error para conexión de red
class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.message =
        'No hay conexión a internet. Verifica tu red y vuelve a intentar.',
  });

  final VoidCallback? onRetry;
  final String message;

  @override
  Widget build(BuildContext context) => ErrorDisplayWidget(
        title: 'Sin conexión',
        message: message,
        icon: Icons.wifi_off,
        onRetry: onRetry,
      );
}

/// Widget de error para permisos
class PermissionErrorWidget extends StatelessWidget {
  const PermissionErrorWidget({
    super.key,
    this.onRetry,
    this.message = 'No tienes permisos para acceder a esta funcionalidad.',
  });

  final VoidCallback? onRetry;
  final String message;

  @override
  Widget build(BuildContext context) => ErrorDisplayWidget(
        title: 'Acceso denegado',
        message: message,
        icon: Icons.lock_outline,
        onRetry: onRetry,
      );
}

/// Widget de error para servidor
class ServerErrorWidget extends StatelessWidget {
  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.message = 'Error del servidor. Intenta nuevamente más tarde.',
  });

  final VoidCallback? onRetry;
  final String message;

  @override
  Widget build(BuildContext context) => ErrorDisplayWidget(
        title: 'Error del servidor',
        message: message,
        icon: Icons.cloud_off,
        onRetry: onRetry,
      );
}
