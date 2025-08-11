import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:flutter/material.dart';

class AnteprojectActionsWidget extends StatelessWidget {
  final Anteproject anteproject;
  final VoidCallback onActionCompleted;

  const AnteprojectActionsWidget({
    super.key,
    required this.anteproject,
    required this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar edición
                      onActionCompleted();
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar eliminación
                      onActionCompleted();
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
