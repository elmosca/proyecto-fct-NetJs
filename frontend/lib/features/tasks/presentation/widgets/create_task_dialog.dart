import 'package:fct_frontend/core/widgets/app_text_field.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTaskDialog extends ConsumerStatefulWidget {
  final String projectId;
  final String? milestoneId;

  const CreateTaskDialog({
    super.key,
    required this.projectId,
    this.milestoneId,
  });

  @override
  ConsumerState<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends ConsumerState<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedHoursController = TextEditingController();
  final _tagsController = TextEditingController();
  final _assigneesController = TextEditingController();

  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskComplexity _selectedComplexity = TaskComplexity.medium;
  DateTime? _selectedDueDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedHoursController.dispose();
    _tagsController.dispose();
    _assigneesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.createTask),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _titleController,
                label: l10n.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${l10n.title} es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${l10n.description} es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      value: _selectedPriority,
                      decoration: InputDecoration(
                        labelText: l10n.priority,
                        border: const OutlineInputBorder(),
                      ),
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(_getPriorityText(priority, l10n)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<TaskComplexity>(
                      value: _selectedComplexity,
                      decoration: InputDecoration(
                        labelText: l10n.complexity,
                        border: const OutlineInputBorder(),
                      ),
                      items: TaskComplexity.values.map((complexity) {
                        return DropdownMenuItem(
                          value: complexity,
                          child: Text(_getComplexityText(complexity, l10n)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedComplexity = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _estimatedHoursController,
                      decoration: InputDecoration(
                        labelText: l10n.estimatedHours,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _selectDueDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.dueDate,
                          border: const OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedDueDate != null
                              ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                              : 'Seleccionar fecha',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _tagsController,
                label: l10n.tags,
                hint: 'tag1, tag2, tag3',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _assigneesController,
                label: l10n.assignees,
                hint: 'user1@email.com, user2@email.com',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createTask,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.submit),
        ),
      ],
    );
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

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final createTaskDto = CreateTaskDto(
        projectId: widget.projectId,
        milestoneId: widget.milestoneId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        complexity: _selectedComplexity,
        dueDate: _selectedDueDate,
        estimatedHours: _estimatedHoursController.text.isNotEmpty
            ? int.tryParse(_estimatedHoursController.text)
            : null,
        tags: _tagsController.text.isNotEmpty
            ? _tagsController.text.split(',').map((e) => e.trim()).toList()
            : [],
        assignees: _assigneesController.text.isNotEmpty
            ? _assigneesController.text.split(',').map((e) => e.trim()).toList()
            : [],
      );

      // TODO: [REVIEW_NEEDED] - Implementar creación de tarea cuando se resuelva el provider
      // await ref.read(tasksNotifierProvider.notifier).createTask(createTaskDto);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea creada exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear tarea: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
