import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../domain/entities/task_report_entity.dart';

class TaskReportCard extends StatelessWidget {
  final TaskReport report;
  final VoidCallback? onDelete;
  final VoidCallback? onExport;
  final VoidCallback? onSchedule;

  const TaskReportCard({
    super.key,
    required this.report,
    this.onDelete,
    this.onExport,
    this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getReportIcon(report.type),
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context, report.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  report.type.displayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (report.generatedAt != null) ...[
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(report.generatedAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            if (report.projectId != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.project}: ${report.projectId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onExport != null)
                  TextButton.icon(
                    onPressed: onExport,
                    icon: const Icon(Icons.download),
                    label: Text(l10n.export),
                  ),
                if (onSchedule != null) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onSchedule,
                    icon: const Icon(Icons.schedule),
                    label: Text(l10n.schedule),
                  ),
                ],
                if (onDelete != null) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    label: Text(l10n.delete),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, TaskReportStatus status) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    Color color;
    IconData icon;
    String text;

    switch (status) {
      case TaskReportStatus.pending:
        color = theme.colorScheme.outline;
        icon = Icons.schedule;
        text = l10n.pending;
        break;
      case TaskReportStatus.generating:
        color = theme.colorScheme.primary;
        icon = Icons.hourglass_empty;
        text = l10n.generating;
        break;
      case TaskReportStatus.completed:
        color = theme.colorScheme.tertiary;
        icon = Icons.check_circle;
        text = l10n.completed;
        break;
      case TaskReportStatus.failed:
        color = theme.colorScheme.error;
        icon = Icons.error;
        text = l10n.failed;
        break;
      case TaskReportStatus.expired:
        color = theme.colorScheme.outline;
        icon = Icons.access_time_filled;
        text = l10n.expired;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getReportIcon(TaskReportType type) {
    switch (type) {
      case TaskReportType.taskStatusSummary:
        return Icons.assessment;
      case TaskReportType.taskProgressByUser:
        return Icons.people;
      case TaskReportType.taskProgressByProject:
        return Icons.folder;
      case TaskReportType.taskOverdueSummary:
        return Icons.warning;
      case TaskReportType.taskCompletionTrends:
        return Icons.trending_up;
      case TaskReportType.taskPriorityDistribution:
        return Icons.priority_high;
      case TaskReportType.taskComplexityAnalysis:
        return Icons.psychology;
      case TaskReportType.taskDependencyAnalysis:
        return Icons.account_tree;
      case TaskReportType.taskTimeAnalysis:
        return Icons.timer;
      case TaskReportType.taskCustomReport:
        return Icons.analytics;
    }
  }
}
