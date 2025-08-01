import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_report_dto.dart';
import '../../domain/entities/task_report_entity.dart';
import '../providers/task_report_providers.dart';

class CreateReportDialog extends ConsumerStatefulWidget {
  const CreateReportDialog({super.key});

  @override
  ConsumerState<CreateReportDialog> createState() => _CreateReportDialogState();
}

class _CreateReportDialogState extends ConsumerState<CreateReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskReportType _selectedType = TaskReportType.taskStatusSummary;
  String? _selectedProjectId;
  String? _selectedMilestoneId;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Reporte'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskReportType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Reporte',
                  border: OutlineInputBorder(),
                ),
                items: TaskReportType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ID del Proyecto (opcional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _selectedProjectId = value.isEmpty ? null : value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ID del Milestone (opcional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _selectedMilestoneId = value.isEmpty ? null : value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Fecha Desde (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _fromDate = date;
                          });
                        }
                      },
                      controller: TextEditingController(
                        text: _fromDate != null
                            ? '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'
                            : '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Fecha Hasta (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _toDate = date;
                          });
                        }
                      },
                      controller: TextEditingController(
                        text: _toDate != null
                            ? '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _createReport,
          child: const Text('Crear'),
        ),
      ],
    );
  }

  Future<void> _createReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final dto = CreateTaskReportDto(
        title: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        projectId: _selectedProjectId,
        milestoneId: _selectedMilestoneId,
        filters: {
          if (_fromDate != null) 'fromDate': _fromDate!.toIso8601String(),
          if (_toDate != null) 'toDate': _toDate!.toIso8601String(),
        },
      );

      await ref.read(taskReportsNotifierProvider.notifier).generateReport(dto);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte creado exitosamente'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear reporte: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
