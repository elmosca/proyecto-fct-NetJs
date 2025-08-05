import 'package:flutter/material.dart';

import '../../domain/entities/project_entity.dart';

class ProjectFiltersWidget extends StatefulWidget {
  final ProjectStatus? selectedStatus;
  final Function(ProjectStatus?) onFiltersChanged;

  const ProjectFiltersWidget({
    super.key,
    this.selectedStatus,
    required this.onFiltersChanged,
  });

  @override
  State<ProjectFiltersWidget> createState() => _ProjectFiltersWidgetState();
}

class _ProjectFiltersWidgetState extends State<ProjectFiltersWidget> {
  ProjectStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtros de Proyectos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado del Proyecto',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...ProjectStatus.values.map((status) => RadioListTile<ProjectStatus>(
                title: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: status.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(status.displayName),
                  ],
                ),
                value: status,
                groupValue: _selectedStatus,
                onChanged: (ProjectStatus? value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              )),
          const SizedBox(height: 8),
          RadioListTile<ProjectStatus?>(
            title: const Text('Todos los estados'),
            value: null,
            groupValue: _selectedStatus,
            onChanged: (ProjectStatus? value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onFiltersChanged(_selectedStatus);
            Navigator.of(context).pop();
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
