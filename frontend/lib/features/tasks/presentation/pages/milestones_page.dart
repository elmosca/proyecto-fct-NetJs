import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/milestone_providers.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/create_milestone_dialog.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/milestone_card.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class MilestonesPage extends ConsumerStatefulWidget {
  final String? projectId;

  const MilestonesPage({
    super.key,
    this.projectId,
  });

  @override
  ConsumerState<MilestonesPage> createState() => _MilestonesPageState();
}

class _MilestonesPageState extends ConsumerState<MilestonesPage> {
  @override
  void initState() {
    super.initState();
    // Configurar filtros si se proporciona un projectId
    if (widget.projectId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(milestoneFiltersNotifierProvider.notifier)
            .setProjectId(widget.projectId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final milestonesState = ref.watch(milestonesNotifierProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.milestones),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(milestonesNotifierProvider.notifier)
                .refreshMilestones(),
          ),
        ],
      ),
      body: milestonesState.when(
        data: (milestones) => _buildMilestonesList(milestones),
        loading: () => const LoadingWidget(),
        error: (error, stack) => _buildError(error.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateMilestoneDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMilestonesList(List<Milestone> milestones) {
    if (milestones.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.flag,
        title: AppLocalizations.of(context).noMilestones,
        message: AppLocalizations.of(context).noMilestonesMessage,
        onAction: () => _showCreateMilestoneDialog(context),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final milestone = milestones[index];
        return MilestoneCard(
          milestone: milestone,
          onTap: () => _showMilestoneDetails(context, milestone),
          onEdit: () => _showEditMilestoneDialog(context, milestone),
          onDelete: () => _showDeleteMilestoneDialog(context, milestone),
        );
      },
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error al cargar los hitos',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(milestonesNotifierProvider.notifier).refreshMilestones();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showCreateMilestoneDialog(BuildContext context) {
    final projectId =
        widget.projectId ?? 'default-project'; // TODO: Obtener projectId real
    showDialog(
      context: context,
      builder: (context) => CreateMilestoneDialog(projectId: projectId),
    );
  }

  void _showEditMilestoneDialog(BuildContext context, Milestone milestone) {
    // TODO: Implementar diálogo de edición de milestone
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar: ${milestone.title}')),
    );
  }

  void _showMilestoneDetails(BuildContext context, Milestone milestone) {
    // TODO: Implementar navegación a página de detalles
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Detalles de: ${milestone.title}')),
    );
  }

  void _showDeleteMilestoneDialog(BuildContext context, Milestone milestone) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMilestone),
        content: Text(l10n.deleteMilestoneConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteMilestone(milestone);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    // TODO: Implementar diálogo de filtros para milestones
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtros de hitos - En desarrollo')),
    );
  }

  void _deleteMilestone(Milestone milestone) {
    ref.read(milestonesNotifierProvider.notifier).deleteMilestone(milestone.id);
  }
}