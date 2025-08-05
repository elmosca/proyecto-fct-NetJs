import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../domain/entities/milestone_entity.dart';
import '../../domain/entities/task_entity.dart';

class ProgressReportWidget extends ConsumerWidget {
  final List<TaskEntity> tasks;
  final List<MilestoneEntity> milestones;
  final String? projectId;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ProgressReportWidget({
    super.key,
    required this.tasks,
    required this.milestones,
    this.projectId,
    this.fromDate,
    this.toDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, l10n, theme),
          const SizedBox(height: 24),
          _buildSummaryCards(context, l10n, theme),
          const SizedBox(height: 24),
          _buildTaskProgressSection(context, l10n, theme),
          const SizedBox(height: 24),
          _buildMilestoneProgressSection(context, l10n, theme),
          const SizedBox(height: 24),
          _buildTimelineSection(context, l10n, theme),
          const SizedBox(height: 24),
          _buildPerformanceMetrics(context, l10n, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.progressReport,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getDateRangeText(l10n),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _exportReport(context),
                  icon: const Icon(Icons.download),
                  tooltip: l10n.exportReport,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final totalTasks = tasks.length;
    final completedTasks =
        tasks.where((t) => t.status == TaskStatus.completed).length;
    final inProgressTasks =
        tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final pendingTasks =
        tasks.where((t) => t.status == TaskStatus.pending).length;
    final overdueTasks = tasks
        .where((t) =>
            t.dueDate != null &&
            t.dueDate!.isBefore(DateTime.now()) &&
            t.status != TaskStatus.completed)
        .length;

    final totalMilestones = milestones.length;
    final completedMilestones =
        milestones.where((m) => m.status == MilestoneStatus.completed).length;
    final inProgressMilestones =
        milestones.where((m) => m.status == MilestoneStatus.inProgress).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.summary,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                l10n.totalTasks,
                totalTasks.toString(),
                Icons.task,
                Colors.blue,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                l10n.completedTasks,
                completedTasks.toString(),
                Icons.check_circle,
                Colors.green,
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                l10n.inProgressTasks,
                inProgressTasks.toString(),
                Icons.pending,
                Colors.orange,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                l10n.overdueTasks,
                overdueTasks.toString(),
                Icons.warning,
                Colors.red,
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                l10n.totalMilestones,
                totalMilestones.toString(),
                Icons.flag,
                Colors.purple,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                l10n.completedMilestones,
                completedMilestones.toString(),
                Icons.flag_circle,
                Colors.green,
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskProgressSection(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final totalTasks = tasks.length;
    if (totalTasks == 0) {
      return _buildEmptySection(
          context, l10n.noTasksAvailable, Icons.task_outlined, theme);
    }

    final statusCounts = {
      TaskStatus.pending:
          tasks.where((t) => t.status == TaskStatus.pending).length,
      TaskStatus.inProgress:
          tasks.where((t) => t.status == TaskStatus.inProgress).length,
      TaskStatus.completed:
          tasks.where((t) => t.status == TaskStatus.completed).length,
      TaskStatus.cancelled:
          tasks.where((t) => t.status == TaskStatus.cancelled).length,
    };

    final priorityCounts = {
      TaskPriority.low:
          tasks.where((t) => t.priority == TaskPriority.low).length,
      TaskPriority.medium:
          tasks.where((t) => t.priority == TaskPriority.medium).length,
      TaskPriority.high:
          tasks.where((t) => t.priority == TaskPriority.high).length,
      TaskPriority.critical:
          tasks.where((t) => t.priority == TaskPriority.critical).length,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.taskProgress,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressChart(
                    context,
                    l10n.taskStatus,
                    statusCounts.map((key, value) =>
                        MapEntry(_getStatusText(key, l10n), value)),
                    [Colors.grey, Colors.orange, Colors.green, Colors.red],
                    theme,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProgressChart(
                    context,
                    l10n.taskPriority,
                    priorityCounts.map((key, value) =>
                        MapEntry(_getPriorityText(key, l10n), value)),
                    [Colors.blue, Colors.orange, Colors.red, Colors.purple],
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTaskList(context, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneProgressSection(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final totalMilestones = milestones.length;
    if (totalMilestones == 0) {
      return _buildEmptySection(
          context, l10n.noMilestonesAvailable, Icons.flag_outlined, theme);
    }

    final statusCounts = {
      MilestoneStatus.pending:
          milestones.where((m) => m.status == MilestoneStatus.pending).length,
      MilestoneStatus.inProgress: milestones
          .where((m) => m.status == MilestoneStatus.inProgress)
          .length,
      MilestoneStatus.completed:
          milestones.where((m) => m.status == MilestoneStatus.completed).length,
      MilestoneStatus.cancelled:
          milestones.where((m) => m.status == MilestoneStatus.cancelled).length,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.milestoneProgress,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressChart(
              context,
              l10n.milestoneStatus,
              statusCounts.map((key, value) =>
                  MapEntry(_getMilestoneStatusText(key, l10n), value)),
              [Colors.grey, Colors.orange, Colors.green, Colors.red],
              theme,
            ),
            const SizedBox(height: 16),
            _buildMilestoneList(context, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(
    BuildContext context,
    String title,
    Map<String, int> data,
    List<Color> colors,
    ThemeData theme,
  ) {
    final total = data.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...data.entries.map((entry) {
          final percentage = total > 0 ? (entry.value / total * 100) : 0.0;
          final colorIndex =
              data.keys.toList().indexOf(entry.key) % colors.length;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: colors[colorIndex].withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(colors[colorIndex]),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTaskList(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final recentTasks = tasks.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentTasks,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...recentTasks
            .map((task) => _buildTaskItem(context, task, l10n, theme))
            .toList(),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskEntity task,
      AppLocalizations l10n, ThemeData theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(task.status).withOpacity(0.1),
        child: Icon(
          _getStatusIcon(task.status),
          color: _getStatusColor(task.status),
          size: 20,
        ),
      ),
      title: Text(
        task.title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${_getStatusText(task.status, l10n)} • ${_getPriorityText(task.priority, l10n)}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: task.dueDate != null
          ? Text(
              _formatDate(task.dueDate!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: task.dueDate!.isBefore(DateTime.now()) &&
                        task.status != TaskStatus.completed
                    ? Colors.red
                    : theme.colorScheme.outline,
              ),
            )
          : null,
    );
  }

  Widget _buildMilestoneList(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final recentMilestones = milestones.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentMilestones,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...recentMilestones
            .map((milestone) =>
                _buildMilestoneItem(context, milestone, l10n, theme))
            .toList(),
      ],
    );
  }

  Widget _buildMilestoneItem(BuildContext context, MilestoneEntity milestone,
      AppLocalizations l10n, ThemeData theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            _getMilestoneStatusColor(milestone.status).withOpacity(0.1),
        child: Icon(
          _getMilestoneStatusIcon(milestone.status),
          color: _getMilestoneStatusColor(milestone.status),
          size: 20,
        ),
      ),
      title: Text(
        milestone.title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${_getMilestoneStatusText(milestone.status, l10n)} • ${milestone.type.displayName}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: milestone.plannedDate != null
          ? Text(
              _formatDate(milestone.plannedDate),
              style: theme.textTheme.bodySmall?.copyWith(
                color: milestone.plannedDate.isBefore(DateTime.now()) &&
                        milestone.status != MilestoneStatus.completed
                    ? Colors.red
                    : theme.colorScheme.outline,
              ),
            )
          : null,
    );
  }

  Widget _buildTimelineSection(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final allItems = <_TimelineItem>[];

    // Agregar tareas completadas
    for (final task in tasks.where((t) => t.completedAt != null)) {
      allItems.add(_TimelineItem(
        title: task.title,
        date: task.completedAt!,
        type: _TimelineItemType.task,
        status: task.status,
      ));
    }

    // Agregar milestones completados
    for (final milestone in milestones.where((m) => m.completedAt != null)) {
      allItems.add(_TimelineItem(
        title: milestone.title,
        date: milestone.completedAt!,
        type: _TimelineItemType.milestone,
        status: milestone.status,
      ));
    }

    // Ordenar por fecha
    allItems.sort((a, b) => b.date.compareTo(a.date));
    final recentItems = allItems.take(10).toList();

    if (recentItems.isEmpty) {
      return _buildEmptySection(
          context, l10n.noRecentActivity, Icons.timeline, theme);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.recentActivity,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...recentItems
                .map((item) => _buildTimelineItem(context, item, l10n, theme))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, _TimelineItem item,
      AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: item.type == _TimelineItemType.task
                  ? Colors.blue
                  : Colors.purple,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${item.type == _TimelineItemType.task ? l10n.task : l10n.milestone} • ${_formatDate(item.date)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final totalTasks = tasks.length;
    final completedTasks =
        tasks.where((t) => t.status == TaskStatus.completed).length;
    final completionRate =
        totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0.0;

    final totalMilestones = milestones.length;
    final completedMilestones =
        milestones.where((m) => m.status == MilestoneStatus.completed).length;
    final milestoneCompletionRate = totalMilestones > 0
        ? (completedMilestones / totalMilestones * 100)
        : 0.0;

    final averageTaskDuration = _calculateAverageTaskDuration();
    final onTimeCompletionRate = _calculateOnTimeCompletionRate();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.performanceMetrics,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    l10n.taskCompletionRate,
                    '${completionRate.toStringAsFixed(1)}%',
                    Icons.check_circle_outline,
                    Colors.green,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    l10n.milestoneCompletionRate,
                    '${milestoneCompletionRate.toStringAsFixed(1)}%',
                    Icons.flag_outlined,
                    Colors.purple,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    l10n.averageTaskDuration,
                    averageTaskDuration,
                    Icons.schedule,
                    Colors.blue,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    l10n.onTimeCompletionRate,
                    '${onTimeCompletionRate.toStringAsFixed(1)}%',
                    Icons.timer,
                    Colors.orange,
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySection(
      BuildContext context, String message, IconData icon, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _getDateRangeText(AppLocalizations l10n) {
    if (fromDate != null && toDate != null) {
      return '${_formatDate(fromDate!)} - ${_formatDate(toDate!)}';
    } else if (fromDate != null) {
      return '${l10n.from} ${_formatDate(fromDate!)}';
    } else if (toDate != null) {
      return '${l10n.to} ${_formatDate(toDate!)}';
    }
    return l10n.allTime;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(TaskStatus status, AppLocalizations l10n) {
    switch (status) {
      case TaskStatus.pending:
        return l10n.pending;
      case TaskStatus.inProgress:
        return l10n.inProgress;
      case TaskStatus.completed:
        return l10n.completed;
      case TaskStatus.cancelled:
        return l10n.cancelled;
    }
  }

  String _getPriorityText(TaskPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TaskPriority.low:
        return l10n.lowPriority;
      case TaskPriority.medium:
        return l10n.mediumPriority;
      case TaskPriority.high:
        return l10n.highPriority;
      case TaskPriority.critical:
        return l10n.criticalPriority;
    }
  }

  String _getMilestoneStatusText(
      MilestoneStatus status, AppLocalizations l10n) {
    switch (status) {
      case MilestoneStatus.pending:
        return l10n.pending;
      case MilestoneStatus.inProgress:
        return l10n.inProgress;
      case MilestoneStatus.completed:
        return l10n.completed;
      case MilestoneStatus.cancelled:
        return l10n.cancelled;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  Color _getMilestoneStatusColor(MilestoneStatus status) {
    switch (status) {
      case MilestoneStatus.pending:
        return Colors.grey;
      case MilestoneStatus.inProgress:
        return Colors.orange;
      case MilestoneStatus.completed:
        return Colors.green;
      case MilestoneStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }

  IconData _getMilestoneStatusIcon(MilestoneStatus status) {
    switch (status) {
      case MilestoneStatus.pending:
        return Icons.flag_outlined;
      case MilestoneStatus.inProgress:
        return Icons.flag;
      case MilestoneStatus.completed:
        return Icons.flag_circle;
      case MilestoneStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _calculateAverageTaskDuration() {
    final completedTasks = tasks
        .where((t) => t.status == TaskStatus.completed && t.completedAt != null)
        .toList();

    if (completedTasks.isEmpty) return 'N/A';

    final totalDuration = completedTasks.fold<Duration>(
      Duration.zero,
      (total, task) => total + task.completedAt!.difference(task.createdAt),
    );

    final averageDays = totalDuration.inDays / completedTasks.length;
    return '${averageDays.toStringAsFixed(1)} días';
  }

  double _calculateOnTimeCompletionRate() {
    final completedTasks = tasks
        .where((t) =>
            t.status == TaskStatus.completed &&
            t.dueDate != null &&
            t.completedAt != null)
        .toList();

    if (completedTasks.isEmpty) return 0.0;

    final onTimeTasks = completedTasks
        .where((t) =>
            t.completedAt!.isBefore(t.dueDate!) ||
            t.completedAt!.isAtSameMomentAs(t.dueDate!))
        .length;

    return (onTimeTasks / completedTasks.length) * 100;
  }

  void _exportReport(BuildContext context) {
    // TODO: Implementar exportación del reporte
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).exportReport),
      ),
    );
  }
}

class _TimelineItem {
  final String title;
  final DateTime date;
  final _TimelineItemType type;
  final dynamic status;

  _TimelineItem({
    required this.title,
    required this.date,
    required this.type,
    required this.status,
  });
}

enum _TimelineItemType {
  task,
  milestone,
}
