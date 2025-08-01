import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart'
    as app_report;
import 'package:flutter/material.dart';

class ReportCardWidget extends StatelessWidget {
  final app_report.Report report;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const ReportCardWidget({
    super.key,
    required this.report,
    required this.onDownload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForType(report.type),
                  color: _getColorForType(report.type),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        report.type.displayName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'download':
                        onDownload();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download),
                          SizedBox(width: 8),
                          Text('Descargar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              report.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report.format.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(report.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            if (report.generatedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'Generado: ${_formatDate(report.generatedAt!)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(app_report.ReportType type) {
    switch (type) {
      case app_report.ReportType.anteprojectSummary:
        return Icons.assignment;
      case app_report.ReportType.defenseSchedule:
        return Icons.schedule;
      case app_report.ReportType.evaluationResults:
        return Icons.assessment;
      case app_report.ReportType.studentPerformance:
        return Icons.trending_up;
      case app_report.ReportType.tutorWorkload:
        return Icons.work;
      case app_report.ReportType.custom:
        return Icons.description;
    }
  }

  Color _getColorForType(app_report.ReportType type) {
    switch (type) {
      case app_report.ReportType.anteprojectSummary:
        return Colors.blue;
      case app_report.ReportType.defenseSchedule:
        return Colors.orange;
      case app_report.ReportType.evaluationResults:
        return Colors.green;
      case app_report.ReportType.studentPerformance:
        return Colors.purple;
      case app_report.ReportType.tutorWorkload:
        return Colors.indigo;
      case app_report.ReportType.custom:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
