import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../providers/task_report_providers.dart';
import '../widgets/create_report_dialog.dart';
import '../widgets/task_report_card.dart';

@RoutePage()
class TaskReportsPage extends ConsumerStatefulWidget {
  const TaskReportsPage({super.key});

  @override
  ConsumerState<TaskReportsPage> createState() => _TaskReportsPageState();
}

class _TaskReportsPageState extends ConsumerState<TaskReportsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reportsAsync = ref.watch(taskReportsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskReportsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(taskReportsNotifierProvider.notifier).refreshReports();
            },
            tooltip: l10n.refresh,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateReportDialog(context);
            },
            tooltip: l10n.createReport,
          ),
        ],
      ),
      body: reportsAsync.when(
        data: (reports) {
          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assessment_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noReportsAvailable,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.createFirstReport,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateReportDialog(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createReport),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(taskReportsNotifierProvider.notifier).refreshReports();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskReportCard(
                    report: report,
                    onDelete: () => _deleteReport(report.id),
                    onExport: () => _exportReport(report.id),
                    onSchedule: () => _scheduleReport(report.id),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingReports,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(taskReportsNotifierProvider.notifier)
                      .refreshReports();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateReportDialog(),
    );
  }

  Future<void> _deleteReport(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteReport),
        content: Text(AppLocalizations.of(context).deleteReportConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(taskReportsNotifierProvider.notifier).deleteReport(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).reportDeleted),
          ),
        );
      }
    }
  }

  Future<void> _exportReport(String id) async {
    try {
      final exportDto = TaskReportExportDto(
        reportId: id,
        format: 'pdf',
      );
      await ref
          .read(taskReportsNotifierProvider.notifier)
          .exportReport(id, exportDto);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).reportExported),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorExportingReport),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _scheduleReport(String id) async {
    // TODO: Implementar diálogo de programación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).featureNotImplemented),
      ),
    );
  }
}
