import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart'
    as app_report;
import 'package:fct_frontend/features/anteprojects/presentation/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({super.key});

  @override
  ConsumerState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  String _selectedDataType = 'anteprojects';
  app_report.ReportFormat _selectedFormat = app_report.ReportFormat.pdf;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedTutorId;
  String? _selectedStudentId;

  final List<Map<String, String>> _dataTypes = [
    {'value': 'anteprojects', 'label': 'Anteproyectos'},
    {'value': 'defenses', 'label': 'Defensas'},
    {'value': 'evaluations', 'label': 'Evaluaciones'},
    {'value': 'students', 'label': 'Estudiantes'},
    {'value': 'tutors', 'label': 'Tutores'},
    {'value': 'reports', 'label': 'Reportes'},
  ];

  @override
  Widget build(BuildContext context) {
    final exportAsync = ref.watch(exportNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar Datos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuración de exportación
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuración de Exportación',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tipo de datos
                    DropdownButtonFormField<String>(
                      value: _selectedDataType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Datos',
                        border: OutlineInputBorder(),
                      ),
                      items: _dataTypes.map((type) {
                        return DropdownMenuItem(
                          value: type['value'],
                          child: Text(type['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedDataType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Formato de exportación
                    DropdownButtonFormField<app_report.ReportFormat>(
                      value: _selectedFormat,
                      decoration: const InputDecoration(
                        labelText: 'Formato de Exportación',
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
                    const SizedBox(height: 16),

                    // Rango de fechas
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _selectDateRange(context),
                            icon: const Icon(Icons.date_range),
                            label: Text(_getDateRangeText()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filtros adicionales
                    if (_selectedDataType == 'anteprojects' ||
                        _selectedDataType == 'defenses' ||
                        _selectedDataType == 'evaluations') ...[
                      const Text(
                        'Filtros Adicionales',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'ID del Tutor (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _selectedTutorId =
                              value.trim().isNotEmpty ? value.trim() : null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'ID del Estudiante (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _selectedStudentId =
                              value.trim().isNotEmpty ? value.trim() : null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Botón de exportación
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: exportAsync.isLoading ? null : _exportData,
                        icon: exportAsync.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.download),
                        label: Text(exportAsync.isLoading
                            ? 'Exportando...'
                            : 'Exportar Datos'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Estado de la exportación
            exportAsync.when(
              data: (downloadUrl) {
                if (downloadUrl != null) {
                  return Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exportación Completada',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Los datos han sido exportados exitosamente.'),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _downloadFile(downloadUrl),
                              icon: const Icon(Icons.download),
                              label: const Text('Descargar Archivo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Procesando exportación...'),
                    ],
                  ),
                ),
              ),
              error: (error, stackTrace) => Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Error en la Exportación',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _exportData,
                          child: const Text('Reintentar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Información adicional
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información de Exportación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '• Los archivos se generan en el servidor y están disponibles para descarga.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Los archivos grandes pueden tardar varios minutos en generarse.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Los archivos se eliminan automáticamente después de 24 horas.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Formato actual: ${_selectedFormat.displayName}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateRangeText() {
    if (_fromDate != null && _toDate != null) {
      return '${_fromDate!.day}/${_fromDate!.month} - ${_toDate!.day}/${_toDate!.month}';
    } else if (_fromDate != null) {
      return 'Desde ${_fromDate!.day}/${_fromDate!.month}';
    } else if (_toDate != null) {
      return 'Hasta ${_toDate!.day}/${_toDate!.month}';
    }
    return 'Seleccionar rango de fechas';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });
    }
  }

  void _exportData() {
    final filters = <String, dynamic>{
      'fromDate': _fromDate?.toIso8601String(),
      'toDate': _toDate?.toIso8601String(),
    };

    if (_selectedTutorId != null) {
      filters['tutorId'] = _selectedTutorId;
    }

    if (_selectedStudentId != null) {
      filters['studentId'] = _selectedStudentId;
    }

    ref.read(exportNotifierProvider.notifier).exportData(
          dataType: _selectedDataType,
          format: _selectedFormat,
          filters: filters,
        );
  }

  void _downloadFile(String downloadUrl) {
    // TODO: Implementar descarga de archivo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando archivo desde: $downloadUrl'),
      ),
    );
  }
}
