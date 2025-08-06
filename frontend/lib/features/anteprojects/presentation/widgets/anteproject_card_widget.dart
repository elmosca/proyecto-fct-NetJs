import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:flutter/material.dart';

class AnteprojectCardWidget extends StatelessWidget {
  final Anteproject anteproject;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSubmit;

  const AnteprojectCardWidget({
    super.key,
    required this.anteproject,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      anteproject.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                anteproject.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    anteproject.studentName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (anteproject.tutorName != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.school,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      anteproject.tutorName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(anteproject.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                      tooltip: 'Editar',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: onDelete,
                      tooltip: 'Eliminar',
                    ),
                  if (onSubmit != null)
                    IconButton(
                      icon: const Icon(Icons.send, size: 20),
                      onPressed: onSubmit,
                      tooltip: 'Enviar',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    Color textColor;

    switch (anteproject.status) {
      case AnteprojectStatus.draft:
        chipColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        break;
      case AnteprojectStatus.submitted:
        chipColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case AnteprojectStatus.underReview:
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      case AnteprojectStatus.approved:
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case AnteprojectStatus.rejected:
        chipColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        break;
      case AnteprojectStatus.defenseScheduled:
        chipColor = Colors.purple.shade100;
        textColor = Colors.purple.shade700;
        break;
      case AnteprojectStatus.defenseCompleted:
        chipColor = Colors.indigo.shade100;
        textColor = Colors.indigo.shade700;
        break;
      case AnteprojectStatus.completed:
        chipColor = Colors.teal.shade100;
        textColor = Colors.teal.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        anteproject.status.displayName,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
