import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/task_providers.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFiltersDialog extends ConsumerStatefulWidget {
  const TaskFiltersDialog({super.key});

  @override
  ConsumerState<TaskFiltersDialog> createState() => _TaskFiltersDialogState();
}

class _TaskFiltersDialogState extends ConsumerState<TaskFiltersDialog> {
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;
  TaskComplexity? _selectedComplexity;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCurrentFilters() {
    // TODO: [REVIEW_NEEDED] - Implementar cuando se defina taskFiltersNotifierProvider
    // final filters = ref.read(taskFiltersNotifierProvider);
    // _selectedStatus = filters.status;
    // _selectedPriority = filters.priority;
    // _selectedComplexity = filters.complexity;
    // _dateFrom = filters.dueDateFrom;
    // _dateTo = filters.dueDateTo;
    // _searchController.text = filters.searchQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.filters),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Búsqueda
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.searchTasksHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),

            // Estado
            DropdownButtonFormField<TaskStatus?>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: l10n.status,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...TaskStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusText(status, l10n)),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Prioridad
            DropdownButtonFormField<TaskPriority?>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: l10n.priority,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...TaskPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(_getPriorityText(priority, l10n)),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Complejidad
            DropdownButtonFormField<TaskComplexity?>(
              value: _selectedComplexity,
              decoration: InputDecoration(
                labelText: l10n.complexity,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...TaskComplexity.values.map((complexity) {
                  return DropdownMenuItem(
                    value: complexity,
                    child: Text(_getComplexityText(complexity, l10n)),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedComplexity = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Rango de fechas
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '${l10n.selectDateRange} (Desde)',
                        border: const OutlineInputBorder(),
                      ),
                      child: Text(
                        _dateFrom != null
                            ? '${_dateFrom!.day}/${_dateFrom!.month}/${_dateFrom!.year}'
                            : 'Seleccionar',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '${l10n.selectDateRange} (Hasta)',
                        border: const OutlineInputBorder(),
                      ),
                      child: Text(
                        _dateTo != null
                            ? '${_dateTo!.day}/${_dateTo!.month}/${_dateTo!.year}'
                            : 'Seleccionar',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearFilters,
          child: Text(l10n.clear),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: Text(l10n.apply),
        ),
      ],
    );
  }

  String _getStatusText(TaskStatus status, AppLocalizations l10n) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.underReview:
        return 'En Revisión';
      case TaskStatus.completed:
        return 'Completada';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  String _getPriorityText(TaskPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.critical:
        return 'Crítica';
    }
  }

  String _getComplexityText(TaskComplexity complexity, AppLocalizations l10n) {
    switch (complexity) {
      case TaskComplexity.simple:
        return 'Simple';
      case TaskComplexity.medium:
        return 'Media';
      case TaskComplexity.complex:
        return 'Compleja';
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isFrom ? (_dateFrom ?? DateTime.now()) : (_dateTo ?? DateTime.now()),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedPriority = null;
      _selectedComplexity = null;
      _dateFrom = null;
      _dateTo = null;
      _searchController.clear();
    });
  }

  void _applyFilters() {
    final filters = TaskFiltersDto(
      status: _selectedStatus,
      priority: _selectedPriority,
      complexity: _selectedComplexity,
      dueDateFrom: _dateFrom,
      dueDateTo: _dateTo,
      searchQuery:
          _searchController.text.isNotEmpty ? _searchController.text : null,
    );

    // TODO: [REVIEW_NEEDED] - Implementar cuando se defina taskFiltersNotifierProvider
    // ref.read(taskFiltersNotifierProvider.notifier).updateFilters(filters);
    Navigator.of(context).pop();
  }
}
