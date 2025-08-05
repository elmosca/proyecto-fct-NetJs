import 'package:fct_frontend/core/services/audit_service.dart';
import 'package:flutter/material.dart';
import 'package:fct_frontend/core/extensions/color_extensions.dart';
import 'package:intl/intl.dart';

class AuditLogItem extends StatelessWidget {
  const AuditLogItem({
    super.key,
    required this.log,
    this.onTap,
  });

  final AuditLogEntity log;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: _buildSeverityIcon(),
        title: Text(
          log.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    log.userName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(log.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (log.ipAddress != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    log.ipAddress!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionTypeChip(),
            const SizedBox(height: 4),
            _buildSeverityChip(),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityIcon() {
    IconData iconData;
    Color color;

    switch (log.severity) {
      case AuditSeverity.low:
        iconData = Icons.info_outline;
        color = Colors.blue;
        break;
      case AuditSeverity.medium:
        iconData = Icons.warning_outlined;
        color = Colors.orange;
        break;
      case AuditSeverity.high:
        iconData = Icons.error_outline;
        color = Colors.red;
        break;
      case AuditSeverity.critical:
        iconData = Icons.dangerous_outlined;
        color = Colors.purple;
        break;
    }

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  Widget _buildActionTypeChip() {
    String label;
    Color color;

    switch (log.actionType) {
      case AuditActionType.create:
        label = 'Crear';
        color = Colors.green;
        break;
      case AuditActionType.update:
        label = 'Actualizar';
        color = Colors.blue;
        break;
      case AuditActionType.delete:
        label = 'Eliminar';
        color = Colors.red;
        break;
      case AuditActionType.login:
        label = 'Login';
        color = Colors.green;
        break;
      case AuditActionType.logout:
        label = 'Logout';
        color = Colors.grey;
        break;
      case AuditActionType.passwordChange:
        label = 'Contraseña';
        color = Colors.orange;
        break;
      case AuditActionType.roleChange:
        label = 'Rol';
        color = Colors.purple;
        break;
      case AuditActionType.statusChange:
        label = 'Estado';
        color = Colors.amber;
        break;
      case AuditActionType.export:
        label = 'Exportar';
        color = Colors.teal;
        break;
      case AuditActionType.bulkAction:
        label = 'Masivo';
        color = Colors.indigo;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSeverityChip() {
    String label;
    Color color;

    switch (log.severity) {
      case AuditSeverity.low:
        label = 'Baja';
        color = Colors.blue;
        break;
      case AuditSeverity.medium:
        label = 'Media';
        color = Colors.orange;
        break;
      case AuditSeverity.high:
        label = 'Alta';
        color = Colors.red;
        break;
      case AuditSeverity.critical:
        label = 'Crítica';
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
