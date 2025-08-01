import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../providers/milestone_providers.dart';
import '../providers/task_providers.dart';
import '../widgets/progress_report_widget.dart';

@RoutePage()
class ProgressReportPage extends ConsumerStatefulWidget {
  final String? projectId;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ProgressReportPage({
    super.key,
    this.projectId,
    this.fromDate,
    this.toDate,
  });

  @override
  ConsumerState<ProgressReportPage> createState() => _ProgressReportPageState();
}

class _ProgressReportPageState extends ConsumerState<ProgressReportPage> {
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _selectedFromDate = widget.fromDate;
    _selectedToDate = widget.toDate;
    _selectedProjectId = widget.projectId;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progressReport),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: l10n.filter,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: _buildBody(context, l10n, theme),
    );
  }

  Widget _buildBody(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final tasksAsync = ref.watch(tasksNotifierProvider);
    final milestonesAsync = ref.watch(milestonesNotifierProvider);

    return tasksAsync.when(
      data: (tasks) {
        return milestonesAsync.when(
          data: (milestones) {
            // Filtrar datos según los filtros seleccionados
            final filteredTasks = _filterTasks(tasks);
            final filteredMilestones = _filterMilestones(milestones);

            return ProgressReportWidget(
              tasks: filteredTasks,
              milestones: filteredMilestones,
              projectId: _selectedProjectId,
              fromDate: _selectedFromDate,
              toDate: _selectedToDate,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              _buildErrorWidget(context, error, l10n, theme),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          _buildErrorWidget(context, error, l10n, theme),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object error,
      AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.errorLoadingData,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.filterReport),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Filtro de proyecto
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.projectId,
                    border: const OutlineInputBorder(),
                    hintText: l10n.allProjects,
                  ),
                  initialValue: _selectedProjectId,
                  onChanged: (value) {
                    setState(() {
                      _selectedProjectId = value.isEmpty ? null : value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Filtro de fecha desde
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.fromDate,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedFromDate != null
                        ? '${_selectedFromDate!.day}/${_selectedFromDate!.month}/${_selectedFromDate!.year}'
                        : '',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedFromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedFromDate = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Filtro de fecha hasta
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.toDate,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedToDate != null
                        ? '${_selectedToDate!.day}/${_selectedToDate!.month}/${_selectedToDate!.year}'
                        : '',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedToDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedToDate = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Botones para limpiar filtros
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFromDate = null;
                            _selectedToDate = null;
                            _selectedProjectId = null;
                          });
                        },
                        child: Text(l10n.clearFilters),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _refreshData();
                        },
                        child: Text(l10n.apply),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  List<TaskEntity> _filterTasks(List<TaskEntity> tasks) {
    var filteredTasks = tasks;

    // Filtrar por proyecto
    if (_selectedProjectId != null) {
      filteredTasks = filteredTasks
          .where((task) => task.projectId == _selectedProjectId)
          .toList();
    }

    // Filtrar por fecha de creación
    if (_selectedFromDate != null) {
      filteredTasks = filteredTasks
          .where((task) =>
              task.createdAt.isAfter(_selectedFromDate!) ||
              task.createdAt.isAtSameMomentAs(_selectedFromDate!))
          .toList();
    }

    if (_selectedToDate != null) {
      filteredTasks = filteredTasks
          .where((task) =>
              task.createdAt
                  .isBefore(_selectedToDate!.add(const Duration(days: 1))) ||
              task.createdAt.isAtSameMomentAs(_selectedToDate!))
          .toList();
    }

    return filteredTasks;
  }

  List<MilestoneEntity> _filterMilestones(List<MilestoneEntity> milestones) {
    var filteredMilestones = milestones;

    // Filtrar por proyecto
    if (_selectedProjectId != null) {
      filteredMilestones = filteredMilestones
          .where((milestone) => milestone.projectId == _selectedProjectId)
          .toList();
    }

    // Filtrar por fecha de creación
    if (_selectedFromDate != null) {
      filteredMilestones = filteredMilestones
          .where((milestone) =>
              milestone.createdAt.isAfter(_selectedFromDate!) ||
              milestone.createdAt.isAtSameMomentAs(_selectedFromDate!))
          .toList();
    }

    if (_selectedToDate != null) {
      filteredMilestones = filteredMilestones
          .where((milestone) =>
              milestone.createdAt
                  .isBefore(_selectedToDate!.add(const Duration(days: 1))) ||
              milestone.createdAt.isAtSameMomentAs(_selectedToDate!))
          .toList();
    }

    return filteredMilestones;
  }

  void _refreshData() {
    // Refrescar datos de tareas y milestones
    ref.read(tasksNotifierProvider.notifier).refreshTasks();
    ref.read(milestonesNotifierProvider.notifier).refreshMilestones();
  }
}
