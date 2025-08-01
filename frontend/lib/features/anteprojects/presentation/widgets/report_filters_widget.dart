import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart'
    as app_report;
import 'package:fct_frontend/features/anteprojects/domain/entities/report_filters.dart';
import 'package:flutter/material.dart';

class ReportFiltersWidget extends StatefulWidget {
  final ReportFilters filters;
  final Function(ReportFilters) onFiltersChanged;
  final VoidCallback onClearFilters;

  const ReportFiltersWidget({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    required this.onClearFilters,
  });

  @override
  State<ReportFiltersWidget> createState() => _ReportFiltersWidgetState();
}

class _ReportFiltersWidgetState extends State<ReportFiltersWidget> {
  late TextEditingController _searchController;
  app_report.ReportType? _selectedType;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedType = widget.filters.type;
    _fromDate = widget.filters.fromDate;
    _toDate = widget.filters.toDate;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por título',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _updateFilters();
              },
            ),
            const SizedBox(height: 16),

            // Filtros de tipo y fecha
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<app_report.ReportType?>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Reporte',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos los tipos'),
                      ),
                      ...app_report.ReportType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                      _updateFilters();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDateRange(context),
                    icon: const Icon(Icons.date_range),
                    label: Text(_getDateRangeText()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onClearFilters,
                    child: const Text('Limpiar Filtros'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateFilters,
                    child: const Text('Aplicar Filtros'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDateRangeText() {
    if (_fromDate != null && _toDate != null) {
      return '${_fromDate!.day}/${_fromDate!.month} - ${_toDate!.day}/${_toDate!.month}';
    } else if (_fromDate != null) {
      return 'Desde ${_fromDate!.day}/${_fromDate!.month}';
    } else if (_toDate != null) {
      return 'Hasta ${_toDate!.day}/${_toDate!.month}';
    }
    return 'Seleccionar fechas';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });
      _updateFilters();
    }
  }

  void _updateFilters() {
    final newFilters = ReportFilters(
      userId: _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null,
      type: _selectedType,
      fromDate: _fromDate,
      toDate: _toDate,
    );
    widget.onFiltersChanged(newFilters);
  }
}
