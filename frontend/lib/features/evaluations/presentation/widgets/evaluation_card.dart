import 'package:flutter/material.dart';

import '../../domain/entities/evaluation.dart';

class EvaluationCard extends StatelessWidget {
  final Evaluation evaluation;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSubmit;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const EvaluationCard({
    super.key,
    required this.evaluation,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSubmit,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildContent(context),
              const SizedBox(height: 12),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evaluation.anteprojectTitle ??
                    'Anteproyecto ${evaluation.anteprojectId}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Evaluador: ${evaluation.evaluatorName ?? 'Usuario ${evaluation.evaluatorId}'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        _buildStatusChip(context),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(),
          width: 1,
        ),
      ),
      child: Text(
        evaluation.status.displayName,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.score, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              'Puntuación: ${evaluation.totalScore.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Text(
              '${evaluation.scores.length} criterios',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        if (evaluation.comments.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            evaluation.comments,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 8),
        Text(
          'Creada: ${_formatDate(evaluation.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (evaluation.status.canEdit) ...[
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: onEdit,
            tooltip: 'Editar',
            color: Colors.blue,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: onDelete,
            tooltip: 'Eliminar',
            color: Colors.red,
          ),
        ],
        if (evaluation.status.canSubmit) ...[
          IconButton(
            icon: const Icon(Icons.send, size: 20),
            onPressed: onSubmit,
            tooltip: 'Enviar',
            color: Colors.green,
          ),
        ],
        if (evaluation.status.canApprove) ...[
          IconButton(
            icon: const Icon(Icons.check_circle, size: 20),
            onPressed: onApprove,
            tooltip: 'Aprobar',
            color: Colors.green,
          ),
          IconButton(
            icon: const Icon(Icons.cancel, size: 20),
            onPressed: onReject,
            tooltip: 'Rechazar',
            color: Colors.red,
          ),
        ],
      ],
    );
  }

  Color _getStatusColor() {
    switch (evaluation.status) {
      case EvaluationStatus.draft:
        return Colors.orange;
      case EvaluationStatus.submitted:
        return Colors.blue;
      case EvaluationStatus.approved:
        return Colors.green;
      case EvaluationStatus.rejected:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
