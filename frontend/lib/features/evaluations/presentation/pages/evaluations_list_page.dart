import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/i18n/app_localizations.dart';
import 'package:fct_frontend/core/theme/app_theme.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/error_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/evaluation.dart';
import '../providers/evaluation_providers.dart';
import '../widgets/evaluation_card.dart';
import '../widgets/evaluation_filter_dialog.dart';

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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.evaluationsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: l10n.filter,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToCreateEvaluation(),
            tooltip: l10n.createEvaluation,
          ),
        ],
      ),
      body: evaluationsAsync.when(
        data: (evaluations) => _buildEvaluationsList(evaluations),
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => ErrorWidget(
          message: error.toString(),
          onRetry: () => _loadEvaluations(),
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
      return EmptyStateWidget(
        icon: Icons.assessment,
        title: AppLocalizations.of(context).noEvaluationsTitle,
        message: AppLocalizations.of(context).noEvaluationsMessage,
        actionText: AppLocalizations.of(context).createFirstEvaluation,
        onAction: () => _navigateToCreateEvaluation(),
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEvaluationTitle),
        content: Text(l10n.deleteEvaluationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteEvaluation(evaluation);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.approveEvaluationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.approveEvaluationMessage),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.comments,
                hintText: l10n.optionalComments,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
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
            child: Text(l10n.approve),
          ),
        ],
      ),
    );
  }

  void _rejectEvaluation(Evaluation evaluation) {
    final l10n = AppLocalizations.of(context);
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rejectEvaluationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.rejectEvaluationMessage),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: l10n.rejectionReason,
                hintText: l10n.rejectionReasonHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
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
            child: Text(l10n.reject),
          ),
        ],
      ),
    );
  }
}
