import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/anteproject_providers.dart';
import 'package:flutter/material.dart';

class AnteprojectFiltersWidget extends StatelessWidget {
  final Function(AnteprojectFilters) onFiltersChanged;

  const AnteprojectFiltersWidget({
    super.key,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar anteproyectos...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    onFiltersChanged(AnteprojectFilters(search: value));
                  },
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusFilter(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(BuildContext context) {
    return PopupMenuButton<AnteprojectStatus?>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Estado'),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: null,
          child: Text('Todos los estados'),
        ),
        ...AnteprojectStatus.values.map((status) => PopupMenuItem(
              value: status,
              child: Text(status.displayName),
            )),
      ],
      onSelected: (status) {
        onFiltersChanged(AnteprojectFilters(status: status));
      },
    );
  }
}
