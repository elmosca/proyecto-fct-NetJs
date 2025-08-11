import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/milestone_providers.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/edit_milestone_dialog.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MilestoneDetailsPage extends ConsumerWidget {
  final MilestoneEntity milestone;

  const MilestoneDetailsPage({
    super.key,
    required this.milestone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.milestoneDetails),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditDialog(context, milestone);
                  break;
                case 'delete':
                  _showDeleteDialog(context, milestone, ref);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 16),
                    const SizedBox(width: 8),
                    Text(l10n.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      l10n.delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildMilestoneDetails(context, milestone, l10n),
    );
  }

  Widget _buildMilestoneDetails(
      BuildContext context, MilestoneEntity milestone, AppLocalizations l10n) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y estado
          _buildHeader(context, milestone, l10n),
          const SizedBox(height: 24),

          // Información básica
          _buildBasicInfo(context, milestone, l10n, dateFormat),
          const SizedBox(height: 24),

          // Descripción
          _buildDescription(context, milestone, l10n),
          const SizedBox(height: 24),

          // Metadatos
          _buildMetadata(context, milestone, l10n, dateFormat),
          const SizedBox(height: 24),

          // Entregables esperados
          if (milestone.expectedDeliverables.isNotEmpty) ...[
            _buildDeliverables(context, milestone, l10n),
            const SizedBox(height: 24),
          ],

          // Comentarios de revisión
          if (milestone.reviewComments != null &&
              milestone.reviewComments!.isNotEmpty) ...[
            _buildReviewComments(context, milestone, l10n),
            const SizedBox(height: 24),
          ],

          // Acciones
          _buildActions(context, milestone, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, MilestoneEntity milestone, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    milestone.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildStatusChip(context, milestone.status, l10n),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: milestone.milestoneType.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: milestone.milestoneType.color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Hito ${milestone.milestoneNumber}',
                    style: TextStyle(
                      color: milestone.milestoneType.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildTypeChip(context, milestone.milestoneType, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context, MilestoneEntity milestone,
      AppLocalizations l10n, DateFormat dateFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.basicInformation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                context, l10n.status, _getStatusText(milestone.status, l10n)),
            _buildInfoRow(context, l10n.milestoneType,
                _getTypeText(milestone.milestoneType, l10n)),
            _buildInfoRow(context, l10n.plannedDate,
                dateFormat.format(milestone.plannedDate)),
            if (milestone.completedDate != null)
              _buildInfoRow(context, l10n.completedDate,
                  dateFormat.format(milestone.completedDate!)),
            _buildInfoRow(context, l10n.createdAt,
                dateFormat.format(milestone.createdAt)),
            if (milestone.updatedAt != null)
              _buildInfoRow(context, l10n.updatedAt,
                  dateFormat.format(milestone.updatedAt!)),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(
      BuildContext context, MilestoneEntity milestone, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              milestone.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, MilestoneEntity milestone,
      AppLocalizations l10n, DateFormat dateFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.metadata,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, 'ID', milestone.id),
            _buildInfoRow(context, l10n.project, milestone.projectId),
            _buildInfoRow(context, l10n.createdAt,
                dateFormat.format(milestone.createdAt)),
            if (milestone.updatedAt != null)
              _buildInfoRow(context, l10n.updatedAt,
                  dateFormat.format(milestone.updatedAt!)),
            if (milestone.isFromAnteproject)
              _buildInfoRow(context, l10n.isFromAnteproject, 'Sí'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliverables(
      BuildContext context, MilestoneEntity milestone, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expectedDeliverables,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: milestone.expectedDeliverables
                  .map((deliverable) => Chip(
                        label: Text(deliverable),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewComments(
      BuildContext context, MilestoneEntity milestone, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reviewComments,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              milestone.reviewComments!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(
      BuildContext context, MilestoneEntity milestone, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.actions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditDialog(context, milestone),
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.edit),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _changeStatus(context, milestone),
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(l10n.changeStatus),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteDialog(context, milestone, null),
                icon: const Icon(Icons.delete),
                label: Text(l10n.delete),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context, MilestoneStatus status, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 12,
            color: status.color,
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(status, l10n),
            style: TextStyle(
              color: status.color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(
      BuildContext context, MilestoneType type, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: type.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: type.color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type.icon,
            size: 12,
            color: type.color,
          ),
          const SizedBox(width: 4),
          Text(
            _getTypeText(type, l10n),
            style: TextStyle(
              color: type.color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(MilestoneStatus status, AppLocalizations l10n) {
    switch (status) {
      case MilestoneStatus.pending:
        return 'Pendiente';
      case MilestoneStatus.inProgress:
        return 'En Progreso';
      case MilestoneStatus.completed:
        return 'Completado';
      case MilestoneStatus.delayed:
        return 'Retrasado';
      case MilestoneStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _getTypeText(MilestoneType type, AppLocalizations l10n) {
    switch (type) {
      case MilestoneType.planning:
        return 'Planificación';
      case MilestoneType.execution:
        return 'Ejecución';
      case MilestoneType.review:
        return 'Revisión';
      case MilestoneType.final_:
        return 'Final';
    }
  }

  void _showEditDialog(BuildContext context, MilestoneEntity milestone) {
    showDialog(
      context: context,
      builder: (context) => EditMilestoneDialog(milestone: milestone),
    );
  }

  void _showDeleteDialog(
      BuildContext context, MilestoneEntity milestone, WidgetRef? ref) {
    final l10n = AppLocalizations.of(context)!;
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
              if (ref != null) {
                ref
                    .read(milestonesNotifierProvider.notifier)
                    .deleteMilestone(milestone.id);
              }
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _changeStatus(BuildContext context, MilestoneEntity milestone) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: MilestoneStatus.values.map((status) {
            return ListTile(
              title: Text(_getStatusText(status, l10n)),
              leading: Radio<MilestoneStatus>(
                value: status,
                groupValue: milestone.status,
                onChanged: (value) {
                  if (value != null) {
                    Navigator.of(context).pop();
                    // TODO: Implementar cambio de estado
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Estado cambiado a: ${_getStatusText(value, l10n)}')),
                    );
                  }
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
