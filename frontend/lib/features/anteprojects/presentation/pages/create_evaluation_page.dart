import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation_criteria.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/evaluation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CreateEvaluationPage extends ConsumerStatefulWidget {
  final String defenseId;
  final String evaluatorId;

  const CreateEvaluationPage({
    super.key,
    required this.defenseId,
    required this.evaluatorId,
  });

  @override
  ConsumerState<CreateEvaluationPage> createState() =>
      _CreateEvaluationPageState();
}

class _CreateEvaluationPageState extends ConsumerState<CreateEvaluationPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentsController = TextEditingController();
  final Map<String, double> _scores = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Cargar criterios de evaluación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(evaluationCriteriaNotifierProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final criteriaAsync = ref.watch(evaluationCriteriaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Evaluación'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: criteriaAsync.when(
          data: (criteria) => _buildEvaluationForm(criteria),
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
                        .read(evaluationCriteriaNotifierProvider.notifier)
                        .refresh();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvaluationForm(List<EvaluationCriteria> criteria) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información de la defensa
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de la Defensa',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text('Defensa ID: ${widget.defenseId}'),
                  Text('Evaluador ID: ${widget.evaluatorId}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Criterios de evaluación
          Text(
            'Criterios de Evaluación',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          ...criteria.map((criterion) => _buildCriteriaCard(criterion)),

          const SizedBox(height: 24),

          // Comentarios generales
          TextFormField(
            controller: _commentsController,
            decoration: const InputDecoration(
              labelText: 'Comentarios Generales *',
              hintText: 'Ingrese comentarios sobre la evaluación',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Los comentarios son requeridos';
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      _isLoading ? null : () => _createEvaluation(criteria),
                  child: const Text('Crear Evaluación'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaCard(EvaluationCriteria criterion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        criterion.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        criterion.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text('${criterion.weight.toStringAsFixed(1)}%'),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text('Puntuación:'),
                ),
                Expanded(
                  flex: 2,
                  child: Slider(
                    value: _scores[criterion.id] ?? 0.0,
                    min: 0.0,
                    max: criterion.maxScore,
                    divisions: (criterion.maxScore * 2).round(),
                    label: (_scores[criterion.id] ?? 0.0).toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _scores[criterion.id] = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${(_scores[criterion.id] ?? 0.0).toStringAsFixed(1)}/${criterion.maxScore}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createEvaluation(List<EvaluationCriteria> criteria) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar que todos los criterios tengan puntuación
    for (final criterion in criteria) {
      if (!_scores.containsKey(criterion.id) || _scores[criterion.id] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe puntuar el criterio: ${criterion.name}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear lista de scores
      final scores = criteria
          .map((criterion) => EvaluationScore(
                criteriaId: criterion.id,
                criteriaName: criterion.name,
                score: _scores[criterion.id]!,
                maxScore: criterion.maxScore,
                weight: criterion.weight,
              ))
          .toList();

      await ref.read(evaluationsNotifierProvider.notifier).createEvaluation(
            defenseId: widget.defenseId,
            evaluatorId: widget.evaluatorId,
            scores: scores,
            comments: _commentsController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evaluación creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la evaluación: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
