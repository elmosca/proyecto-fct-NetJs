import 'package:flutter/material.dart';

import '../../domain/entities/task_export_entity.dart';

class TaskExportCard extends StatelessWidget {
  final TaskExport export;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  const TaskExportCard({
    super.key,
    required this.export,
    this.onTap,
    this.onDownload,
    this.onDelete,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
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
                    _getExportIcon(),
                    color: _getExportColor(theme),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          export.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          export.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(theme),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.file_download_outlined,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    export.format.displayName,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(export.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (export.totalRecords != null) ...[
                    Icon(
                      Icons.table_chart,
                      size: 16,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${export.totalRecords} registros',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              if (export.fileSize != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.storage,
                      size: 16,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      export.fileSize!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
              if (onDownload != null ||
                  onDelete != null ||
                  onCancel != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (export.status.isCompleted && onDownload != null)
                      TextButton.icon(
                        onPressed: onDownload,
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Descargar'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                        ),
                      ),
                    if (export.status.isProcessing && onCancel != null) ...[
                      if (export.status.isCompleted && onDownload != null)
                        const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: onCancel,
                        icon: const Icon(Icons.cancel, size: 16),
                        label: const Text('Cancelar'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange,
                        ),
                      ),
                    ],
                    if (onDelete != null) ...[
                      if ((export.status.isCompleted && onDownload != null) ||
                          (export.status.isProcessing && onCancel != null))
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

  Widget _buildStatusChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(theme).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(theme).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        export.status.displayName,
        style: theme.textTheme.bodySmall?.copyWith(
          color: _getStatusColor(theme),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getExportIcon() {
    switch (export.format) {
      case TaskExportFormat.pdf:
        return Icons.picture_as_pdf;
      case TaskExportFormat.excel:
        return Icons.table_chart;
      case TaskExportFormat.csv:
        return Icons.table_view;
      case TaskExportFormat.json:
        return Icons.code;
    }
  }

  Color _getExportColor(ThemeData theme) {
    switch (export.format) {
      case TaskExportFormat.pdf:
        return Colors.red;
      case TaskExportFormat.excel:
        return Colors.green;
      case TaskExportFormat.csv:
        return Colors.blue;
      case TaskExportFormat.json:
        return Colors.purple;
    }
  }

  Color _getStatusColor(ThemeData theme) {
    switch (export.status) {
      case TaskExportStatus.pending:
        return Colors.orange;
      case TaskExportStatus.processing:
        return Colors.blue;
      case TaskExportStatus.completed:
        return Colors.green;
      case TaskExportStatus.failed:
        return theme.colorScheme.error;
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
