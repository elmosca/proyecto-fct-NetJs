import 'package:fct_frontend/core/services/export_service.dart';
import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({
    super.key,
    required this.users,
    required this.filteredUsers,
    this.selectedUsers = const [],
  });

  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;
  final List<UserEntity> selectedUsers;

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.excel;
  ExportScope _selectedScope = ExportScope.all;
  final Set<String> _selectedFields = <String>{};
  bool _isExporting = false;

  final List<Map<String, String>> _availableFields = [
    {'value': 'id', 'label': 'ID'},
    {'value': 'firstName', 'label': 'Nombre'},
    {'value': 'lastName', 'label': 'Apellidos'},
    {'value': 'email', 'label': 'Email'},
    {'value': 'role', 'label': 'Rol'},
    {'value': 'isActive', 'label': 'Estado'},
    {'value': 'createdAt', 'label': 'Fecha de Creación'},
    {'value': 'avatar', 'label': 'Avatar'},
  ];

  @override
  void initState() {
    super.initState();
    // Seleccionar campos por defecto
    _selectedFields
        .addAll(['id', 'firstName', 'lastName', 'email', 'role', 'isActive']);
  }

  List<UserEntity> get _usersToExport {
    switch (_selectedScope) {
      case ExportScope.all:
        return widget.users;
      case ExportScope.filtered:
        return widget.filteredUsers;
      case ExportScope.selected:
        return widget.selectedUsers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.file_download,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          const Text('Exportar Usuarios'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de exportación
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuarios a exportar: ${_usersToExport.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Formato: ${_getFormatDisplayName(_selectedFormat)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Formato de exportación
            const Text(
              'Formato de archivo:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ExportFormat.values.map((format) {
                return ChoiceChip(
                  label: Text(_getFormatDisplayName(format)),
                  selected: _selectedFormat == format,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFormat = format;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Alcance de exportación
            const Text(
              'Alcance de exportación:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                RadioListTile<ExportScope>(
                  title: Text('Todos los usuarios (${widget.users.length})'),
                  value: ExportScope.all,
                  groupValue: _selectedScope,
                  onChanged: (value) {
                    setState(() {
                      _selectedScope = value!;
                    });
                  },
                ),
                RadioListTile<ExportScope>(
                  title: Text(
                      'Usuarios filtrados (${widget.filteredUsers.length})'),
                  value: ExportScope.filtered,
                  groupValue: _selectedScope,
                  onChanged: (value) {
                    setState(() {
                      _selectedScope = value!;
                    });
                  },
                ),
                if (widget.selectedUsers.isNotEmpty)
                  RadioListTile<ExportScope>(
                    title: Text(
                        'Usuarios seleccionados (${widget.selectedUsers.length})'),
                    value: ExportScope.selected,
                    groupValue: _selectedScope,
                    onChanged: (value) {
                      setState(() {
                        _selectedScope = value!;
                      });
                    },
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Campos a exportar
            const Text(
              'Campos a exportar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                itemCount: _availableFields.length,
                itemBuilder: (context, index) {
                  final field = _availableFields[index];
                  return CheckboxListTile(
                    title: Text(field['label']!),
                    value: _selectedFields.contains(field['value']),
                    onChanged: (checked) {
                      setState(() {
                        if (checked!) {
                          _selectedFields.add(field['value']!);
                        } else {
                          _selectedFields.remove(field['value']!);
                        }
                      });
                    },
                    dense: true,
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Botones de selección rápida
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFields.clear();
                      _selectedFields
                          .addAll(_availableFields.map((f) => f['value']!));
                    });
                  },
                  child: const Text('Seleccionar todos'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFields.clear();
                    });
                  },
                  child: const Text('Limpiar'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: _isExporting ? null : _exportData,
          icon: _isExporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.file_download),
          label: Text(_isExporting ? 'Exportando...' : 'Exportar'),
        ),
      ],
    );
  }

  String _getFormatDisplayName(ExportFormat format) {
    switch (format) {
      case ExportFormat.csv:
        return 'CSV';
      case ExportFormat.excel:
        return 'Excel';
      case ExportFormat.pdf:
        return 'PDF';
    }
  }

  Future<void> _exportData() async {
    if (_selectedFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un campo para exportar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      final exportService = ExportService();
      final filePath = await exportService.exportUsers(
        users: _usersToExport,
        format: _selectedFormat,
        scope: _selectedScope,
        selectedFields: _selectedFields.toList(),
      );

      if (filePath != null) {
        if (mounted) {
          Navigator.of(context).pop();
          _showSuccessDialog(filePath);
        }
      } else {
        throw Exception('No se pudo crear el archivo');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  void _showSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            const Text('Exportación Completada'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Se exportaron ${_usersToExport.length} usuarios.'),
            const SizedBox(height: 8),
            Text(
              'Archivo guardado en:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              filePath,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await ExportService().shareFile(filePath);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al compartir: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.share),
            label: const Text('Compartir'),
          ),
        ],
      ),
    );
  }
}
