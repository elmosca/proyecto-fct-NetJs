import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/app_button.dart';
import 'package:fct_frontend/core/widgets/app_text_field.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/evaluation.dart';
import '../../domain/entities/evaluation_criteria.dart';
import '../providers/evaluation_providers.dart';
import '../widgets/evaluation_form.dart';

@RoutePage()
class CreateEvaluationPage extends ConsumerStatefulWidget {
  const CreateEvaluationPage({super.key});

  @override
  ConsumerState<CreateEvaluationPage> createState() =>
      _CreateEvaluationPageState();
}

class _CreateEvaluationPageState extends ConsumerState<CreateEvaluationPage> {
  final _formKey = GlobalKey<FormState>();
  final _anteprojectController = TextEditingController();
  final _commentsController = TextEditingController();

  List<EvaluationCriteria> _criteria = [];
  Map<String, double> _scores = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCriteria();
  }

  @override
  void dispose() {
    _anteprojectController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final criteriaAsync = ref.watch(evaluationCriteriaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Evaluación'),
      ),
      body: criteriaAsync.when(
        data: (criteria) => _buildForm(criteria),
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => ErrorWidget(
          message: error.toString(),
          onRetry: _loadCriteria,
        ),
      ),
    );
  }

  Widget _buildForm(List<EvaluationCriteria> criteria) {
    _criteria = criteria;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _anteprojectController,
              label: 'ID del Anteproyecto',
              hint: 'Ingrese el ID del anteproyecto',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El ID del anteproyecto es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _commentsController,
              label: 'Comentarios',
              hint: 'Comentarios adicionales sobre la evaluación',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Criterios de Evaluación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCriteriaSection(),
            const SizedBox(height: 24),
            _buildSummarySection(),
            const SizedBox(height: 32),
            AppButton(
              text: _isLoading ? 'Creando...' : 'Crear Evaluación',
              onPressed: _isLoading ? null : _createEvaluation,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaSection() {
    return Column(
      children: _criteria.map((criterion) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  criterion.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  criterion.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Puntuación máxima: ${criterion.maxScore}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Puntuación',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requerido';
                          }
                          final score = double.tryParse(value);
                          if (score == null) {
                            return 'Número válido';
                          }
                          if (score < 0 || score > criterion.maxScore) {
                            return '0-${criterion.maxScore}';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final score = double.tryParse(value);
                          if (score != null) {
                            _scores[criterion.id] = score;
                          } else {
                            _scores.remove(criterion.id);
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummarySection() {
    final totalScore = _scores.values.fold(0.0, (sum, score) => sum + score);
    final maxPossibleScore =
        _criteria.fold(0.0, (sum, criterion) => sum + criterion.maxScore);
    final percentage =
        maxPossibleScore > 0 ? (totalScore / maxPossibleScore) * 100 : 0.0;

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Evaluación',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Puntuación Total:'),
                Text(
                  '${totalScore.toStringAsFixed(1)} / ${maxPossibleScore.toStringAsFixed(1)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Porcentaje:'),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Calificación:'),
                Text(
                  _getGrade(percentage),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _loadCriteria() {
    ref.read(evaluationCriteriaNotifierProvider.notifier).loadCriteria();
  }

  void _createEvaluation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_scores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe evaluar al menos un criterio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final totalScore = _scores.values.fold(0.0, (sum, score) => sum + score);

      final evaluation = Evaluation(
        id: '', // Se asignará en el backend
        anteprojectId: _anteprojectController.text,
        evaluatorId: '1', // TODO: Obtener del usuario actual
        scores: _criteria.map((criterion) {
          return EvaluationScore(
            criteriaId: criterion.id,
            criteriaName: criterion.name,
            score: _scores[criterion.id] ?? 0.0,
            maxScore: criterion.maxScore,
          );
        }).toList(),
        totalScore: totalScore,
        comments: _commentsController.text,
        status: EvaluationStatus.draft,
        createdAt: DateTime.now(),
      );

      await ref
          .read(evaluationsNotifierProvider.notifier)
          .createEvaluation(evaluation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evaluación creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.router.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear evaluación: $e'),
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

  String _getGrade(double percentage) {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }
}
