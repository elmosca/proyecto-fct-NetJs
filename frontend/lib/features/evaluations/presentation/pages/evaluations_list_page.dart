import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/evaluations/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/evaluations/presentation/providers/evaluation_providers.dart';
import 'package:fct_frontend/features/evaluations/presentation/widgets/evaluation_card.dart';
import 'package:fct_frontend/features/evaluations/presentation/widgets/evaluation_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class EvaluationsListPage extends ConsumerStatefulWidget {
  const EvaluationsListPage({super.key});

  @override
  ConsumerState<EvaluationsListPage> createState() =>
      _EvaluationsListPageState();
}

class _EvaluationsListPageState extends ConsumerState<EvaluationsListPage> {
  String? _selectedAnteprojectId;
  String? _selectedEvaluatorId;
  EvaluationStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Cargar evaluaciones al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(evaluationsNotifierProvider.notifier).loadEvaluations(
            anteprojectId: _selectedAnteprojectId,
            evaluatorId: _selectedEvaluatorId,
            status: _selectedStatus,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final evaluationsAsync = ref.watch(evaluationsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filtros',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToCreateEvaluation(),
            tooltip: 'Crear Evaluación',
          ),
        ],
      ),
      body: evaluationsAsync.when(
        data: (evaluations) => _buildEvaluationsList(evaluations),
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadEvaluations,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateEvaluation(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEvaluationsList(List<Evaluation> evaluations) {
    if (evaluations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assessment, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No hay evaluaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crea la primera evaluación para comenzar',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToCreateEvaluation(),
              child: const Text('Crear Evaluación'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadEvaluations(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: evaluations.length,
        itemBuilder: (context, index) {
          final evaluation = evaluations[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EvaluationCard(
              evaluation: evaluation,
              onTap: () => _navigateToEvaluationDetail(evaluation),
              onEdit: () => _navigateToEditEvaluation(evaluation),
              onDelete: () => _showDeleteConfirmation(evaluation),
              onSubmit: () => _submitEvaluation(evaluation),
              onApprove: () => _approveEvaluation(evaluation),
              onReject: () => _rejectEvaluation(evaluation),
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => EvaluationFilterDialog(
        selectedAnteprojectId: _selectedAnteprojectId,
        selectedEvaluatorId: _selectedEvaluatorId,
        selectedStatus: _selectedStatus,
        onApply: (anteprojectId, evaluatorId, status) {
          setState(() {
            _selectedAnteprojectId = anteprojectId;
            _selectedEvaluatorId = evaluatorId;
            _selectedStatus = status;
          });
          _loadEvaluations();
          Navigator.of(context).pop();
        },
        onClear: () {
          setState(() {
            _selectedAnteprojectId = null;
            _selectedEvaluatorId = null;
            _selectedStatus = null;
          });
          _loadEvaluations();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _loadEvaluations() {
    ref.read(evaluationsNotifierProvider.notifier).loadEvaluations(
          anteprojectId: _selectedAnteprojectId,
          evaluatorId: _selectedEvaluatorId,
          status: _selectedStatus,
        );
  }

  void _navigateToCreateEvaluation() {
    context.router.pushNamed('/evaluations/create');
  }

  void _navigateToEvaluationDetail(Evaluation evaluation) {
    context.router.pushNamed('/evaluations/${evaluation.id}');
  }

  void _navigateToEditEvaluation(Evaluation evaluation) {
    context.router.pushNamed('/evaluations/${evaluation.id}/edit');
  }

  void _showDeleteConfirmation(Evaluation evaluation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Evaluación'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar esta evaluación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteEvaluation(evaluation);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _deleteEvaluation(Evaluation evaluation) {
    ref
        .read(evaluationsNotifierProvider.notifier)
        .deleteEvaluation(evaluation.id);
  }

  void _submitEvaluation(Evaluation evaluation) {
    ref
        .read(evaluationsNotifierProvider.notifier)
        .submitEvaluation(evaluation.id);
  }

  void _approveEvaluation(Evaluation evaluation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aprobar Evaluación'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¿Estás seguro de que quieres aprobar esta evaluación?'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Comentarios',
                hintText: 'Comentarios opcionales',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar aprobación con comentarios
              Navigator.of(context).pop();
              ref.read(evaluationsNotifierProvider.notifier).approveEvaluation(
                    evaluation.id,
                    null, // TODO: Obtener comentarios del TextField
                  );
            },
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );
  }

  void _rejectEvaluation(Evaluation evaluation) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar Evaluación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                '¿Estás seguro de que quieres rechazar esta evaluación?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Motivo del rechazo',
                hintText: 'Explica el motivo del rechazo',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                ref.read(evaluationsNotifierProvider.notifier).rejectEvaluation(
                      evaluation.id,
                      reasonController.text.trim(),
                    );
              }
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }
}
