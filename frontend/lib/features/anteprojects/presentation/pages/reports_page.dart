import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart'
    as app_report;
import 'package:fct_frontend/features/anteprojects/presentation/providers/report_providers.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/report_card_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/report_filters_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar reportes al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsNotifierProvider.notifier).loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportsNotifierProvider);
    final filters = ref.watch(reportFiltersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(reportsNotifierProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateReportDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          ReportFiltersWidget(
            filters: filters,
            onFiltersChanged: (newFilters) {
              ref
                  .read(reportFiltersNotifierProvider.notifier)
                  .updateFilters(newFilters);
              ref.read(reportsNotifierProvider.notifier).loadReports(
                    userId: newFilters.userId,
                    type: newFilters.type,
                    fromDate: newFilters.fromDate,
                    toDate: newFilters.toDate,
                  );
            },
            onClearFilters: () {
              ref.read(reportFiltersNotifierProvider.notifier).clearFilters();
              ref.read(reportsNotifierProvider.notifier).loadReports();
            },
          ),

          // Lista de reportes
          Expanded(
            child: reportsAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay reportes disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ReportCardWidget(
                        report: report,
                        onDownload: () => _downloadReport(report.id),
                        onDelete: () => _deleteReport(report.id),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar reportes: $error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(reportsNotifierProvider.notifier).refresh();
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateReportDialog(),
    );
  }

  void _downloadReport(String reportId) {
    // TODO: Implementar descarga de reporte
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Descargando reporte...'),
      ),
    );
  }

  void _deleteReport(String reportId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Reporte'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este reporte?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(reportsNotifierProvider.notifier).deleteReport(reportId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reporte eliminado'),
                ),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class CreateReportDialog extends ConsumerStatefulWidget {
  const CreateReportDialog({super.key});

  @override
  ConsumerState<CreateReportDialog> createState() => _CreateReportDialogState();
}

class _CreateReportDialogState extends ConsumerState<CreateReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  app_report.ReportType _selectedType =
      app_report.ReportType.anteprojectSummary;
  app_report.ReportFormat _selectedFormat = app_report.ReportFormat.pdf;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Nuevo Reporte'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<app_report.ReportType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Reporte',
                  border: OutlineInputBorder(),
                ),
                items: app_report.ReportType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<app_report.ReportFormat>(
                value: _selectedFormat,
                decoration: const InputDecoration(
                  labelText: 'Formato',
                  border: OutlineInputBorder(),
                ),
                items: app_report.ReportFormat.values.map((format) {
                  return DropdownMenuItem(
                    value: format,
                    child: Text(format.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFormat = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _createReport,
          child: const Text('Crear'),
        ),
      ],
    );
  }

  void _createReport() {
    if (_formKey.currentState!.validate()) {
      // TODO: Obtener userId del usuario actual
      const userId = 'current-user-id';

      ref.read(reportsNotifierProvider.notifier).createReport(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            type: _selectedType,
            format: _selectedFormat,
            parameters: {
              'type': _selectedType.name,
              'format': _selectedFormat.name,
            },
            userId: userId,
          );

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte creado exitosamente'),
        ),
      );
    }
  }
}
