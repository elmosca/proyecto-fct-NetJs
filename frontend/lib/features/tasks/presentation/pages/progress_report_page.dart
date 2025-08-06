import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: [REVIEW_NEEDED] - Esta página necesita revisión completa después de resolver errores de linter
// Cambios temporales realizados:
// - Removidos imports de providers no definidos
// - Comentado código de filtrado de entidades
// - Simplificado build method
// - Agregado placeholder temporal

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
    final l10n = AppLocalizations.of(context)!;

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
      body: _buildBody(context, l10n),
    );
  }

  // TODO: [REVIEW_NEEDED] - Implementar lógica real de providers
  // Necesita: TaskEntity, MilestoneEntity, providers configurados
  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    // TEMPORAL: Placeholder mientras se resuelven dependencias
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Progress Report - En desarrollo',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Funcionalidad temporal mientras se resuelven errores',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // TODO: [REVIEW_NEEDED] - Simplificar o remover si no se usa
  void _showFilterDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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

  // TODO: [REVIEW_NEEDED] - Implementar cuando providers estén listos
  // Métodos comentados que necesitan revisión:
  // List<TaskEntity> _filterTasks(List<TaskEntity> tasks) { ... }
  // List<MilestoneEntity> _filterMilestones(List<MilestoneEntity> milestones) { ... }

  // TEMPORAL: Placeholder para refresh
  void _refreshData() {
    // TODO: [REVIEW_NEEDED] - Implementar refresh real
    // ref.read(tasksNotifierProvider.notifier).refreshTasks();
    // ref.read(milestonesNotifierProvider.notifier).refreshMilestones();

    // Por ahora, mostrar feedback temporal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refresh temporal - Funcionalidad en desarrollo'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
