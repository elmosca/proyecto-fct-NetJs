import 'package:flutter/material.dart';

import '../../domain/entities/evaluation.dart';

class EvaluationFilterDialog extends StatefulWidget {
  final String? selectedAnteprojectId;
  final String? selectedEvaluatorId;
  final EvaluationStatus? selectedStatus;
  final Function(String?, String?, EvaluationStatus?) onApply;
  final VoidCallback onClear;

  const EvaluationFilterDialog({
    super.key,
    this.selectedAnteprojectId,
    this.selectedEvaluatorId,
    this.selectedStatus,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<EvaluationFilterDialog> createState() => _EvaluationFilterDialogState();
}

class _EvaluationFilterDialogState extends State<EvaluationFilterDialog> {
  String? _anteprojectId;
  String? _evaluatorId;
  EvaluationStatus? _status;

  @override
  void initState() {
    super.initState();
    _anteprojectId = widget.selectedAnteprojectId;
    _evaluatorId = widget.selectedEvaluatorId;
    _status = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar Evaluaciones'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnteprojectFilter(),
            const SizedBox(height: 16),
            _buildEvaluatorFilter(),
            const SizedBox(height: 16),
            _buildStatusFilter(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onClear,
          child: const Text('Limpiar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () =>
              widget.onApply(_anteprojectId, _evaluatorId, _status),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }

  Widget _buildAnteprojectFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Anteproyecto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: 'ID del anteproyecto',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.assignment),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _anteprojectId = value.isEmpty ? null : value;
            });
          },
          controller: TextEditingController(text: _anteprojectId ?? ''),
        ),
      ],
    );
  }

  Widget _buildEvaluatorFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Evaluador',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: 'ID del evaluador',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _evaluatorId = value.isEmpty ? null : value;
            });
          },
          controller: TextEditingController(text: _evaluatorId ?? ''),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<EvaluationStatus?>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.info),
          ),
          value: _status,
          hint: const Text('Seleccionar estado'),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Todos los estados'),
            ),
            ...EvaluationStatus.values.map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status.displayName),
                )),
          ],
          onChanged: (value) {
            setState(() {
              _status = value;
            });
          },
        ),
      ],
    );
  }
}
