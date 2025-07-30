import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/evaluation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class EvaluationDetailPage extends ConsumerWidget {
  final String evaluationId;

  const EvaluationDetailPage({
    super.key,
    @PathParam('id') required this.evaluationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evaluationAsync =
        ref.watch(evaluationDetailNotifierProvider(evaluationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Evaluación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(evaluationDetailNotifierProvider(evaluationId).notifier)
                  .refresh();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: evaluationAsync.when(
        data: (evaluation) {
          if (evaluation == null) {
            return const Center(
              child: Text('Evaluación no encontrada'),
            );
          }
          return _EvaluationDetailContent(evaluation: evaluation);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(evaluationDetailNotifierProvider(evaluationId)
                          .notifier)
                      .refresh();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EvaluationDetailContent extends ConsumerWidget {
  final Evaluation evaluation;

  const _EvaluationDetailContent({required this.evaluation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con puntuación total
          _buildHeader(context),

          const SizedBox(height: 24),

          // Información básica
          _buildSection(
            context,
            title: 'Información General',
            children: [
              _buildInfoRow('ID de Evaluación:', evaluation.id),
              _buildInfoRow('Defensa ID:', evaluation.defenseId),
              _buildInfoRow('Evaluador ID:', evaluation.evaluatorId),
              _buildInfoRow('Estado:', evaluation.status.displayName),
              _buildInfoRow('Puntuación Total:',
                  '${evaluation.totalScore.toStringAsFixed(1)}/10'),
            ],
          ),

          const SizedBox(height: 16),

          // Criterios evaluados
          _buildSection(
            context,
            title: 'Criterios Evaluados',
            children: evaluation.scores
                .map((score) => _buildScoreCard(score))
                .toList(),
          ),

          const SizedBox(height: 16),

          // Comentarios
          _buildSection(
            context,
            title: 'Comentarios',
            children: [
              Text(
                evaluation.comments,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          // Fechas
          if (evaluation.submittedAt != null) ...[
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: 'Fechas',
              children: [
                _buildInfoRow(
                    'Creado:',
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(evaluation.createdAt)),
                if (evaluation.submittedAt != null)
                  _buildInfoRow(
                      'Enviado:',
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(evaluation.submittedAt!)),
                if (evaluation.updatedAt != null)
                  _buildInfoRow(
                      'Actualizado:',
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(evaluation.updatedAt!)),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // Acciones
          _buildActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (evaluation.status) {
      case EvaluationStatus.draft:
        statusColor = Colors.orange;
        statusIcon = Icons.edit;
        break;
      case EvaluationStatus.submitted:
        statusColor = Colors.blue;
        statusIcon = Icons.send;
        break;
      case EvaluationStatus.approved:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case EvaluationStatus.rejected:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }

    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              statusIcon,
              color: statusColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluación #${evaluation.id.substring(0, 8)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Puntuación: ${evaluation.totalScore.toStringAsFixed(1)}/10',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    evaluation.status.displayName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(EvaluationScore score) {
    final percentage = (score.score / score.maxScore) * 100;
    Color scoreColor;

    if (percentage >= 80) {
      scoreColor = Colors.green;
    } else if (percentage >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        score.criteriaName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Peso: ${score.weight.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${score.score.toStringAsFixed(1)}/${score.maxScore}',
                    style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            if (score.comments != null && score.comments!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                score.comments!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (evaluation.status.canSubmit)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(evaluationsNotifierProvider.notifier)
                            .submitEvaluation(evaluation.id);
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar Evaluación'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (evaluation.status.canApprove) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar aprobación
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Aprobar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (evaluation.status.canReject) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar rechazo
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Rechazar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
