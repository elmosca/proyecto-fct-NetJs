import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_export_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_export_entity.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/task_export_providers.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/create_export_dialog.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_export_card.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskExportsPage extends ConsumerStatefulWidget {
  const TaskExportsPage({super.key});

  @override
  ConsumerState<TaskExportsPage> createState() => _TaskExportsPageState();
}

class _TaskExportsPageState extends ConsumerState<TaskExportsPage> {
  TaskExportFiltersDto _filters = const TaskExportFiltersDto();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExports();
    });
  }

  Future<void> _loadExports() async {
    final notifier = ref.read(taskExportsNotifierProvider.notifier);
    await notifier.loadExports(_filters);
  }

  Future<void> _refreshExports() async {
    final notifier = ref.read(taskExportsNotifierProvider.notifier);
    await notifier.refresh(_filters);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final exportsAsync = ref.watch(taskExportsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskExportsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFiltersDialog,
            tooltip: l10n.filter,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshExports,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshExports,
        child: exportsAsync.when(
          data: (exports) {
            if (exports.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.file_download_outlined,
                title: l10n.noExportsTitle,
                message: l10n.noExportsMessage,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exports.length,
              itemBuilder: (context, index) {
                final export = exports[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TaskExportCard(
                    export: export,
                    onTap: () => _onExportTap(export),
                    onDownload: () => _downloadExport(export.id),
                    onDelete: () => _deleteExport(export.id),
                    onCancel: export.status.isProcessing
                        ? () => _cancelExport(export.id)
                        : null,
                  ),
                );
              },
            );
          },
          loading: () => const LoadingWidget(),
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
                  l10n.errorLoadingExports,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadExports,
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateExportDialog,
        icon: const Icon(Icons.add),
        label: Text(l10n.createExport),
      ),
    );
  }

  void _onExportTap(TaskExport export) {
    // TODO: Implementar navegación a detalles de exportación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Detalles de: ${export.title}'),
      ),
    );
  }

  Future<void> _downloadExport(String exportId) async {
    try {
      final notifier = ref.read(taskExportsNotifierProvider.notifier);
      await notifier.downloadExport(exportId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.exportDownloadStarted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteExport(String exportId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteExport),
        content: Text(AppLocalizations.of(context)!.deleteExportConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final notifier = ref.read(taskExportsNotifierProvider.notifier);
        await notifier.deleteExport(exportId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.exportDeleted),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _cancelExport(String exportId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.cancelExport),
        content: Text(AppLocalizations.of(context)!.cancelExportConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final notifier = ref.read(taskExportsNotifierProvider.notifier);
        await notifier.cancelExport(exportId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.exportCancelled),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showCreateExportDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateExportDialog(),
    );
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => _ExportFiltersDialog(
        filters: _filters,
        onApply: (filters) {
          setState(() {
            _filters = filters;
          });
          _loadExports();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _ExportFiltersDialog extends StatefulWidget {
  final TaskExportFiltersDto filters;
  final Function(TaskExportFiltersDto) onApply;

  const _ExportFiltersDialog({
    required this.filters,
    required this.onApply,
  });

  @override
  State<_ExportFiltersDialog> createState() => _ExportFiltersDialogState();
}

class _ExportFiltersDialogState extends State<_ExportFiltersDialog> {
  late TaskExportFiltersDto _filters;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.filterExports),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<TaskExportFormat?>(
              decoration: InputDecoration(
                labelText: l10n.exportFormat,
                border: const OutlineInputBorder(),
              ),
              value: null, // TODO: Implementar filtro por formato
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.allFormats),
                ),
                ...TaskExportFormat.values.map((format) => DropdownMenuItem(
                      value: format,
                      child: Text(format.displayName),
                    )),
              ],
              onChanged: (value) {
                // TODO: Implementar filtro por formato
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskExportStatus?>(
              decoration: InputDecoration(
                labelText: l10n.exportStatus,
                border: const OutlineInputBorder(),
              ),
              value: null, // TODO: Implementar filtro por estado
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.allStatuses),
                ),
                ...TaskExportStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.displayName),
                    )),
              ],
              onChanged: (value) {
                // TODO: Implementar filtro por estado
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onApply(_filters);
            }
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
