import 'package:fct_frontend/core/widgets/app_text_field.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/milestone_providers.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMilestoneDialog extends ConsumerStatefulWidget {
  final String projectId;

  const CreateMilestoneDialog({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<CreateMilestoneDialog> createState() =>
      _CreateMilestoneDialogState();
}

class _CreateMilestoneDialogState extends ConsumerState<CreateMilestoneDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _milestoneNumberController = TextEditingController();
  final _expectedDeliverablesController = TextEditingController();

  MilestoneType _selectedType = MilestoneType.execution;
  DateTime? _selectedPlannedDate;
  bool _isFromAnteproject = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _milestoneNumberController.dispose();
    _expectedDeliverablesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.createMilestone),
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
                    return l10n.titleRequired;
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
                    return l10n.descriptionRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _milestoneNumberController,
                      decoration: InputDecoration(
                        labelText: l10n.milestoneNumber,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.milestoneNumberRequired;
                        }
                        if (int.tryParse(value) == null) {
                          return 'Debe ser un número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<MilestoneType>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.milestoneType,
                        border: const OutlineInputBorder(),
                      ),
                      items: MilestoneType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getTypeText(type, l10n)),
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
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectPlannedDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.plannedDate,
                          border: const OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedPlannedDate != null
                              ? '${_selectedPlannedDate!.day}/${_selectedPlannedDate!.month}/${_selectedPlannedDate!.year}'
                              : 'Seleccionar fecha',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        l10n.isFromAnteproject,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: _isFromAnteproject,
                      onChanged: (value) {
                        setState(() {
                          _isFromAnteproject = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _expectedDeliverablesController,
                label: l10n.expectedDeliverables,
                hint: 'entregable1, entregable2, entregable3',
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
          onPressed: _isLoading ? null : _createMilestone,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.create),
        ),
      ],
    );
  }

  String _getTypeText(MilestoneType type, AppLocalizations l10n) {
    switch (type) {
      case MilestoneType.planning:
        return 'Planificación';
      case MilestoneType.execution:
        return 'Ejecución';
      case MilestoneType.review:
        return 'Revisión';
      case MilestoneType.final_:
        return 'Final';
    }
  }

  Future<void> _selectPlannedDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPlannedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedPlannedDate) {
      setState(() {
        _selectedPlannedDate = picked;
      });
    }
  }

  Future<void> _createMilestone() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPlannedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.plannedDateRequired)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final createMilestoneDto = CreateMilestoneDto(
        projectId: widget.projectId,
        milestoneNumber: int.parse(_milestoneNumberController.text),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        plannedDate: _selectedPlannedDate!,
        milestoneType: _selectedType,
        isFromAnteproject: _isFromAnteproject,
        expectedDeliverables: _expectedDeliverablesController.text.isNotEmpty
            ? _expectedDeliverablesController.text
                .split(',')
                .map((e) => e.trim())
                .toList()
            : [],
      );

      await ref
          .read(milestonesNotifierProvider.notifier)
          .createMilestone(createMilestoneDto);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hito creado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear hito: $e')),
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
