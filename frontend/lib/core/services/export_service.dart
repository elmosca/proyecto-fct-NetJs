import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

enum ExportFormat { csv, excel, pdf }

enum ExportScope { all, filtered, selected }

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  /// Exporta usuarios en el formato especificado
  Future<String?> exportUsers({
    required List<UserEntity> users,
    required ExportFormat format,
    required ExportScope scope,
    List<String>? selectedFields,
  }) async {
    try {
      // Solicitar permisos si es necesario
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Permisos de almacenamiento no concedidos');
        }
      }

      final fileName = _generateFileName(format, scope);
      final data = _prepareData(users, selectedFields);

      switch (format) {
        case ExportFormat.csv:
          return await _exportToCsv(data, fileName);
        case ExportFormat.excel:
          return await _exportToExcel(data, fileName);
        case ExportFormat.pdf:
          return await _exportToPdf(data, fileName);
      }
    } catch (e) {
      throw Exception('Error al exportar: $e');
    }
  }

  /// Genera el nombre del archivo
  String _generateFileName(ExportFormat format, ExportScope scope) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final scopeText = scope == ExportScope.all
        ? 'todos'
        : scope == ExportScope.filtered
            ? 'filtrados'
            : 'seleccionados';

    switch (format) {
      case ExportFormat.csv:
        return 'usuarios_${scopeText}_$timestamp.csv';
      case ExportFormat.excel:
        return 'usuarios_${scopeText}_$timestamp.xlsx';
      case ExportFormat.pdf:
        return 'usuarios_${scopeText}_$timestamp.pdf';
    }
  }

  /// Prepara los datos para exportación
  List<Map<String, dynamic>> _prepareData(
    List<UserEntity> users,
    List<String>? selectedFields,
  ) {
    final defaultFields = [
      'id',
      'firstName',
      'lastName',
      'email',
      'role',
      'isActive',
      'createdAt',
    ];

    final fields = selectedFields ?? defaultFields;

    return users.map((user) {
      final data = <String, dynamic>{};

      for (final field in fields) {
        switch (field) {
          case 'id':
            data['ID'] = user.id;
            break;
          case 'firstName':
            data['Nombre'] = user.firstName;
            break;
          case 'lastName':
            data['Apellidos'] = user.lastName;
            break;
          case 'email':
            data['Email'] = user.email;
            break;
          case 'role':
            data['Rol'] = _getRoleDisplayName(user.role);
            break;
          case 'isActive':
            data['Estado'] = user.isActive == true ? 'Activo' : 'Inactivo';
            break;
          case 'createdAt':
            data['Fecha de Creación'] = user.createdAt?.toString() ?? 'N/A';
            break;
          case 'avatar':
            data['Avatar'] = user.avatar ?? 'N/A';
            break;
        }
      }

      return data;
    }).toList();
  }

  /// Obtiene el nombre de visualización del rol
  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrador';
      case 'tutor':
        return 'Tutor';
      case 'student':
        return 'Estudiante';
      default:
        return role;
    }
  }

  /// Exporta a CSV
  Future<String?> _exportToCsv(
    List<Map<String, dynamic>> data,
    String fileName,
  ) async {
    if (data.isEmpty) return null;

    final headers = data.first.keys.toList();
    final csvContent = StringBuffer();

    // Añadir encabezados
    csvContent.writeln(headers.map((h) => '"$h"').join(','));

    // Añadir datos
    for (final row in data) {
      final values = headers.map((header) {
        final value = row[header]?.toString() ?? '';
        return '"${value.replaceAll('"', '""')}"';
      });
      csvContent.writeln(values.join(','));
    }

    return await _saveFile(fileName, csvContent.toString());
  }

  /// Exporta a Excel
  Future<String?> _exportToExcel(
    List<Map<String, dynamic>> data,
    String fileName,
  ) async {
    if (data.isEmpty) return null;

    final excel = Excel.createExcel();
    final sheet = excel['Usuarios'];

    // Añadir encabezados
    final headers = data.first.keys.toList();
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = headers[i]
        ..cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          backgroundColorHex: '#E0E0E0',
        );
    }

    // Añadir datos
    for (int rowIndex = 0; rowIndex < data.length; rowIndex++) {
      final row = data[rowIndex];
      for (int colIndex = 0; colIndex < headers.length; colIndex++) {
        final header = headers[colIndex];
        final value = row[header]?.toString() ?? '';

        sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: colIndex,
          rowIndex: rowIndex + 1,
        ))
          ..value = value
          ..cellStyle = CellStyle(
            horizontalAlign: HorizontalAlign.Left,
          );
      }
    }

    final bytes = excel.encode();
    if (bytes == null) return null;

    return await _saveFile(fileName, bytes);
  }

  /// Exporta a PDF (simulado - en una implementación real usarías pdf package)
  Future<String?> _exportToPdf(
    List<Map<String, dynamic>> data,
    String fileName,
  ) async {
    if (data.isEmpty) return null;

    // Por ahora, exportamos como CSV con extensión .pdf
    // En una implementación real, usarías el paquete pdf
    final csvContent =
        await _exportToCsv(data, fileName.replaceAll('.pdf', '.csv'));
    return csvContent?.replaceAll('.csv', '.pdf');
  }

  /// Guarda el archivo y retorna la ruta
  Future<String?> _saveFile(String fileName, dynamic content) async {
    try {
      Directory? directory;

      if (Platform.isAndroid || Platform.isIOS) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('No se pudo obtener el directorio de almacenamiento');
      }

      final downloadsDir = Directory('${directory.path}/Downloads');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final file = File('${downloadsDir.path}/$fileName');

      if (content is String) {
        await file.writeAsString(content);
      } else if (content is Uint8List) {
        await file.writeAsBytes(content);
      } else {
        throw Exception('Tipo de contenido no soportado');
      }

      return file.path;
    } catch (e) {
      throw Exception('Error al guardar archivo: $e');
    }
  }

  /// Comparte el archivo exportado
  Future<void> shareFile(String filePath) async {
    try {
      await Share.shareXFiles([XFile(filePath)]);
    } catch (e) {
      throw Exception('Error al compartir archivo: $e');
    }
  }

  /// Obtiene estadísticas de exportación
  Map<String, dynamic> getExportStats(
      List<UserEntity> users, ExportScope scope) {
    final totalUsers = users.length;
    final activeUsers = users.where((u) => u.isActive == true).length;
    final inactiveUsers = totalUsers - activeUsers;

    final roleStats = <String, int>{};
    for (final user in users) {
      roleStats[user.role] = (roleStats[user.role] ?? 0) + 1;
    }

    return {
      'total': totalUsers,
      'active': activeUsers,
      'inactive': inactiveUsers,
      'roles': roleStats,
      'scope': scope.name,
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }
}
