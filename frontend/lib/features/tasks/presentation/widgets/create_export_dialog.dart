import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fct_frontend/l10n/app_localizations.dart';
import '../../domain/entities/task_export_dto.dart';
import '../../domain/entities/task_export_entity.dart';

class CreateExportDialog extends ConsumerStatefulWidget {
  const CreateExportDialog({super.key});

  @override
  ConsumerState<CreateExportDialog> createState() => _CreateExportDialogState();
}

class _CreateExportDialogState extends ConsumerState<CreateExportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskExportFormat _selectedFormat = TaskExportFormat.excel;
  TaskExportFilters _filters = const TaskExportFilters();
  List<String> _selectedColumns = [];

  @override
  void initState() {
    super.initState();
    _initializeDefaultColumns();
  }

  void _initializeDefaultColumns() {
    // Columnas por defecto para exportación
    _selectedColumns = [
      'id',
      'title',
      'description',
      'status',
      'priority',
      'assignees',
      'dueDate',
      'createdAt',
    ];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.createExport),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.exportTitle,
                  border: const OutlineInputBorder(),
                  hintText: 'Ej: Tareas del Proyecto A',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.titleRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.exportDescription,
                  border: const OutlineInputBorder(),
                  hintText: 'Descripción de la exportación',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskExportFormat>(
                decoration: InputDecoration(
                  labelText: l10n.exportFormat,
                  border: const OutlineInputBorder(),
                ),
                value: _selectedFormat,
                items: TaskExportFormat.values
                    .map((format) => DropdownMenuItem(
                          value: format,
                          child: Row(
                            children: [
                              Icon(_getFormatIcon(format), size: 20),
                              const SizedBox(width: 8),
                              Text(format.displayName),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFormat = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildFiltersSection(l10n),
              const SizedBox(height: 16),
              _buildColumnsSection(l10n),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _createExport,
          child: Text(l10n.create),
        ),
      ],
    );
  }

  Widget _buildFiltersSection(AppLocalizations l10n) {
    return ExpansionTile(
      title: Text(l10n.exportFilters),
      children: [
        const SizedBox(height: 8),
        // Filtros básicos
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.projectId,
            border: const OutlineInputBorder(),
            hintText: 'ID del proyecto (opcional)',
          ),
          onChanged: (value) {
            setState(() {
              _filters =
                  _filters.copyWith(projectId: value.isEmpty ? null : value);
            });
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.milestoneId,
            border: const OutlineInputBorder(),
            hintText: 'ID del milestone (opcional)',
          ),
          onChanged: (value) {
            setState(() {
              _filters =
                  _filters.copyWith(milestoneId: value.isEmpty ? null : value);
            });
          },
        ),
        const SizedBox(height: 8),
        // Filtros de fecha
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: l10n.fromDate,
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: l10n.toDate,
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Filtros de estado
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: l10n.taskStatus,
            border: const OutlineInputBorder(),
          ),
          value: null,
          hint: Text(l10n.selectStatus),
          items: [
            'pending',
            'in_progress',
            'completed',
            'cancelled',
          ]
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _filters = _filters.copyWith(statuses: [value]);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildColumnsSection(AppLocalizations l10n) {
    final availableColumns = [
      {'key': 'id', 'label': 'ID'},
      {'key': 'title', 'label': 'Título'},
      {'key': 'description', 'label': 'Descripción'},
      {'key': 'status', 'label': 'Estado'},
      {'key': 'priority', 'label': 'Prioridad'},
      {'key': 'complexity', 'label': 'Complejidad'},
      {'key': 'assignees', 'label': 'Asignados'},
      {'key': 'dueDate', 'label': 'Fecha de vencimiento'},
      {'key': 'createdAt', 'label': 'Fecha de creación'},
      {'key': 'updatedAt', 'label': 'Fecha de actualización'},
      {'key': 'projectId', 'label': 'ID del proyecto'},
      {'key': 'milestoneId', 'label': 'ID del milestone'},
      {'key': 'tags', 'label': 'Etiquetas'},
      {'key': 'dependencies', 'label': 'Dependencias'},
    ];

    return ExpansionTile(
      title: Text(l10n.exportColumns),
      children: [
        const SizedBox(height: 8),
        ...availableColumns
            .map((column) => CheckboxListTile(
                  title: Text(column['label']!),
                  value: _selectedColumns.contains(column['key']),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedColumns.add(column['key']!);
                      } else {
                        _selectedColumns.remove(column['key']!);
                      }
                    });
                  },
                ))
            .toList(),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: _selectAllColumns,
              child: Text(l10n.selectAll),
            ),
            TextButton(
              onPressed: _deselectAllColumns,
              child: Text(l10n.deselectAll),
            ),
          ],
        ),
      ],
    );
  }

  void _selectDate(bool isFromDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        if (isFromDate) {
          _filters = _filters.copyWith(fromDate: date);
        } else {
          _filters = _filters.copyWith(toDate: date);
        }
      });
    }
  }

  void _selectAllColumns() {
    setState(() {
      _selectedColumns = [
        'id',
        'title',
        'description',
        'status',
        'priority',
        'complexity',
        'assignees',
        'dueDate',
        'createdAt',
        'updatedAt',
        'projectId',
        'milestoneId',
        'tags',
        'dependencies',
      ];
    });
  }

  void _deselectAllColumns() {
    setState(() {
      _selectedColumns.clear();
    });
  }

  IconData _getFormatIcon(TaskExportFormat format) {
    switch (format) {
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

  void _createExport() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedColumns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).selectAtLeastOneColumn),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dto = CreateTaskExportDto(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      format: _selectedFormat,
      filters: _filters,
      columns: _selectedColumns,
    );

    // TODO: Implementar creación de exportación
    Navigator.of(context).pop(dto);
  }
}
