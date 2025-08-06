import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditMilestoneDialog extends ConsumerStatefulWidget {
  final MilestoneEntity milestone;

  const EditMilestoneDialog({
    super.key,
    required this.milestone,
  });

  @override
  ConsumerState<EditMilestoneDialog> createState() =>
      _EditMilestoneDialogState();
}

class _EditMilestoneDialogState extends ConsumerState<EditMilestoneDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _plannedDate;
  late MilestoneType _selectedType;
  late List<String> _deliverables;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.milestone.title);
    _descriptionController =
        TextEditingController(text: widget.milestone.description);
    _plannedDate = widget.milestone.plannedDate;
    _selectedType = widget.milestone.milestoneType;
    _deliverables = List.from(widget.milestone.expectedDeliverables);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.editMilestone ?? 'Editar Hito'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.title ?? 'Título',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.description ?? 'Descripción',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.plannedDate ?? 'Fecha Planificada'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_plannedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MilestoneType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.milestoneType ?? 'Tipo de Hito',
                border: const OutlineInputBorder(),
              ),
              items: MilestoneType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getTypeText(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel ?? 'Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveMilestone,
          child: Text(l10n.save ?? 'Guardar'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _plannedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _plannedDate) {
      setState(() => _plannedDate = picked);
    }
  }

  void _saveMilestone() {
    // TODO: Crear UpdateMilestoneDto con los datos del formulario
    // Por ahora, solo cerramos el diálogo
    Navigator.of(context).pop();
  }

  String _getTypeText(MilestoneType type) {
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
}
