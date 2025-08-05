import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/services/audit_service.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/users/domain/entities/permission_enum.dart';
import 'package:fct_frontend/features/users/presentation/providers/audit_provider.dart';
import 'package:fct_frontend/features/users/presentation/widgets/audit_log_item.dart';
import 'package:fct_frontend/features/users/presentation/widgets/authorized_widget.dart';
import 'package:flutter/material.dart';
import 'package:fct_frontend/core/extensions/color_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AuditLogsPage extends ConsumerStatefulWidget {
  const AuditLogsPage({super.key});

  @override
  ConsumerState<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends ConsumerState<AuditLogsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(auditLogsProvider.notifier).loadAuditLogs();
      ref.read(auditLogsProvider.notifier).loadStats();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(auditLogsProvider.notifier).loadMoreLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auditState = ref.watch(auditLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs de Auditoría'),
        actions: [
          PermissionWidget(
            permission: PermissionEnum.usersView,
            child: IconButton(
              icon: Icon(_showFilters
                  ? Icons.filter_list
                  : Icons.filter_list_outlined),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ),
          PermissionWidget(
            permission: PermissionEnum.usersView,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref
                    .read(auditLogsProvider.notifier)
                    .loadAuditLogs(refresh: true);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Estadísticas
          if (auditState.stats.isNotEmpty)
            PermissionWidget(
              permission: PermissionEnum.usersView,
              child: _buildStatsSection(auditState.stats),
            ),

          // Filtros (expandibles)
          if (_showFilters)
            PermissionWidget(
              permission: PermissionEnum.usersView,
              child: _buildFiltersSection(),
            ),

          // Lista de logs
          Expanded(
            child: _buildLogsList(auditState),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> stats) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas de Auditoría',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total de Logs',
                  stats['totalLogs']?.toString() ?? '0',
                  Icons.assessment,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Hoy',
                  stats['todayLogs']?.toString() ?? '0',
                  Icons.today,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Críticos',
                  stats['criticalLogs']?.toString() ?? '0',
                  Icons.warning,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<AuditActionType>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Acción',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: AuditActionType.values.map((actionType) {
                    return DropdownMenuItem<AuditActionType>(
                      value: actionType,
                      child: Text(_getActionTypeDisplayName(actionType)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(auditLogsProvider.notifier).updateFilters({
                        'actionType': value.name,
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<AuditSeverity>(
                  decoration: const InputDecoration(
                    labelText: 'Severidad',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.priority_high),
                  ),
                  items: AuditSeverity.values.map((severity) {
                    return DropdownMenuItem<AuditSeverity>(
                      value: severity,
                      child: Text(_getSeverityDisplayName(severity)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(auditLogsProvider.notifier).updateFilters({
                        'severity': value.name,
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      ref.read(auditLogsProvider.notifier).updateFilters({
                        'userId': value,
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Recurso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      ref.read(auditLogsProvider.notifier).updateFilters({
                        'resourceType': value,
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(auditLogsProvider.notifier).clearFilters();
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar Filtros'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(AuditLogsState auditState) {
    if (auditState.isLoading && auditState.logs.isEmpty) {
      return const LoadingWidget();
    }

    if (auditState.error != null && auditState.logs.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.error_outline,
        title: 'Error al cargar logs',
        message: auditState.error!,
        actionLabel: 'Reintentar',
        onAction: () {
          ref.read(auditLogsProvider.notifier).loadAuditLogs(refresh: true);
        },
      );
    }

    if (auditState.logs.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.assessment_outlined,
        title: 'No hay logs de auditoría',
        message: 'No se encontraron registros de auditoría para mostrar.',
        actionLabel: 'Recargar',
        onAction: () {
          ref.read(auditLogsProvider.notifier).loadAuditLogs(refresh: true);
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: auditState.logs.length + (auditState.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == auditState.logs.length) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final log = auditState.logs[index];
        return AuditLogItem(
          log: log,
          onTap: () {
            _showLogDetails(log);
          },
        );
      },
    );
  }

  void _showLogDetails(AuditLogEntity log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Detalles del Log'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Descripción', log.description),
              _buildDetailRow('Usuario', log.userName),
              _buildDetailRow('Email', log.userEmail),
              _buildDetailRow(
                  'Tipo de Acción', _getActionTypeDisplayName(log.actionType)),
              _buildDetailRow('Recurso', log.resourceType),
              _buildDetailRow('ID del Recurso', log.resourceId),
              _buildDetailRow(
                  'Severidad', _getSeverityDisplayName(log.severity)),
              _buildDetailRow('Fecha', _formatDateTime(log.timestamp)),
              if (log.ipAddress != null) _buildDetailRow('IP', log.ipAddress!),
              if (log.userAgent != null)
                _buildDetailRow('User Agent', log.userAgent!),
              if (log.oldValues != null && log.oldValues!.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Valores Anteriores:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...log.oldValues!.entries.map((entry) =>
                    _buildDetailRow(entry.key, entry.value.toString())),
              ],
              if (log.newValues != null && log.newValues!.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Valores Nuevos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...log.newValues!.entries.map((entry) =>
                    _buildDetailRow(entry.key, entry.value.toString())),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  String _getActionTypeDisplayName(AuditActionType actionType) {
    switch (actionType) {
      case AuditActionType.create:
        return 'Crear';
      case AuditActionType.update:
        return 'Actualizar';
      case AuditActionType.delete:
        return 'Eliminar';
      case AuditActionType.login:
        return 'Inicio de Sesión';
      case AuditActionType.logout:
        return 'Cierre de Sesión';
      case AuditActionType.passwordChange:
        return 'Cambio de Contraseña';
      case AuditActionType.roleChange:
        return 'Cambio de Rol';
      case AuditActionType.statusChange:
        return 'Cambio de Estado';
      case AuditActionType.export:
        return 'Exportación';
      case AuditActionType.bulkAction:
        return 'Acción Masiva';
    }
  }

  String _getSeverityDisplayName(AuditSeverity severity) {
    switch (severity) {
      case AuditSeverity.low:
        return 'Baja';
      case AuditSeverity.medium:
        return 'Media';
      case AuditSeverity.high:
        return 'Alta';
      case AuditSeverity.critical:
        return 'Crítica';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
