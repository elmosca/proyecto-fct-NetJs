import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:flutter/material.dart';

class AnteprojectDetailWidget extends StatelessWidget {
  final Anteproject anteproject;

  const AnteprojectDetailWidget({
    super.key,
    required this.anteproject,
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
              anteproject.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              anteproject.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Estado', anteproject.status.name),
            _buildDetailRow('Creado', _formatDate(anteproject.createdAt)),
            if (anteproject.updatedAt != null)
              _buildDetailRow(
                  'Actualizado', _formatDate(anteproject.updatedAt!)),
            _buildDetailRow('Estudiante', anteproject.studentName),
            if (anteproject.tutorName != null)
              _buildDetailRow('Tutor', anteproject.tutorName!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
