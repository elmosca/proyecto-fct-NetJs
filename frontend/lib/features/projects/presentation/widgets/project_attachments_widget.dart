import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectAttachmentsWidget extends ConsumerStatefulWidget {
  final String projectId;
  final List<String> currentAttachments;
  final Function(List<String>) onAttachmentsChanged;

  const ProjectAttachmentsWidget({
    super.key,
    required this.projectId,
    required this.currentAttachments,
    required this.onAttachmentsChanged,
  });

  @override
  ConsumerState<ProjectAttachmentsWidget> createState() =>
      _ProjectAttachmentsWidgetState();
}

class _ProjectAttachmentsWidgetState
    extends ConsumerState<ProjectAttachmentsWidget> {
  List<String> _attachments = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _attachments = List.from(widget.currentAttachments);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Archivos Adjuntos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickFiles,
              icon: _isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(_isUploading ? 'Subiendo...' : 'Añadir Archivos'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_attachments.isEmpty)
          const Center(
            child: Column(
              children: [
                Icon(
                  Icons.folder_open,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'No hay archivos adjuntos',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _attachments.length,
            itemBuilder: (context, index) {
              final attachment = _attachments[index];
              return _buildAttachmentTile(attachment, index);
            },
          ),
      ],
    );
  }

  Widget _buildAttachmentTile(String attachment, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _getFileIcon(attachment),
        title: Text(_getFileName(attachment)),
        subtitle: Text(_getFileSize(attachment)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadFile(attachment),
              tooltip: 'Descargar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeAttachment(index),
              tooltip: 'Eliminar',
            ),
          ],
        ),
        onTap: () => _previewFile(attachment),
      ),
    );
  }

  Widget _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: Colors.blue);
      case 'xls':
      case 'xlsx':
        return const Icon(Icons.table_chart, color: Colors.green);
      case 'ppt':
      case 'pptx':
        return const Icon(Icons.slideshow, color: Colors.orange);
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return const Icon(Icons.image, color: Colors.purple);
      case 'zip':
      case 'rar':
        return const Icon(Icons.archive, color: Colors.brown);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
  }

  String _getFileName(String filePath) {
    return filePath.split('/').last;
  }

  String _getFileSize(String filePath) {
    // TODO: Implementar obtención del tamaño real del archivo
    return '1.2 MB';
  }

  Future<void> _pickFiles() async {
    try {
      setState(() {
        _isUploading = true;
      });

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        final newFiles = result.files.map((file) => file.path!).toList();

        // TODO: Implementar subida real de archivos al servidor
        await Future.delayed(const Duration(seconds: 2)); // Simular subida

        setState(() {
          _attachments.addAll(newFiles);
        });

        widget.onAttachmentsChanged(_attachments);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${newFiles.length} archivo(s) subido(s) correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir archivos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeAttachment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Archivo'),
        content: Text(
            '¿Estás seguro de que quieres eliminar "${_getFileName(_attachments[index])}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _attachments.removeAt(index);
              });
              widget.onAttachmentsChanged(_attachments);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Archivo eliminado'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _downloadFile(String filePath) {
    // TODO: Implementar descarga real de archivos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando ${_getFileName(filePath)}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _previewFile(String filePath) {
    // TODO: Implementar preview de archivos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vista previa de ${_getFileName(filePath)}'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
