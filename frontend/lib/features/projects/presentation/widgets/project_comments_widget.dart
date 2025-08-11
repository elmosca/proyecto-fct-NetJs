import 'package:fct_frontend/shared/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectCommentsWidget extends ConsumerStatefulWidget {
  final String projectId;
  final List<Comment> comments;
  final Function(Comment) onCommentAdded;

  const ProjectCommentsWidget({
    super.key,
    required this.projectId,
    required this.comments,
    required this.onCommentAdded,
  });

  @override
  ConsumerState<ProjectCommentsWidget> createState() =>
      _ProjectCommentsWidgetState();
}

class _ProjectCommentsWidgetState extends ConsumerState<ProjectCommentsWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
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
              'Comentarios (${widget.comments.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // TODO: Implementar refresh de comentarios
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comentarios actualizados')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCommentInput(),
        const SizedBox(height: 16),
        _buildCommentsList(),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Añadir comentario',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSubmitting ? null : _clearComment,
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      _isSubmitting || _commentController.text.trim().isEmpty
                          ? null
                          : _submitComment,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Comentar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    if (widget.comments.isEmpty) {
      return const Center(
        child: Column(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'No hay comentarios aún',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '¡Sé el primero en comentar!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        final comment = widget.comments[index];
        return _buildCommentTile(comment);
      },
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    comment.createdBy[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.createdBy,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(comment.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleCommentAction(value, comment),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.content),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.reply, size: 16),
                  label: const Text('Responder'),
                  onPressed: () => _replyToComment(comment),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} día(s) atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora(s) atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto(s) atrás';
    } else {
      return 'Ahora mismo';
    }
  }

  void _clearComment() {
    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implementar envío real de comentario
      await Future.delayed(const Duration(seconds: 1)); // Simular envío

      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _commentController.text.trim(),
        createdBy: 'Usuario Actual', // TODO: Obtener del auth service
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onCommentAdded(newComment);
      _clearComment();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comentario añadido correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al añadir comentario: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _handleCommentAction(String action, Comment comment) {
    switch (action) {
      case 'edit':
        _editComment(comment);
        break;
      case 'delete':
        _deleteComment(comment);
        break;
    }
  }

  void _editComment(Comment comment) {
    // TODO: Implementar edición de comentarios
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de edición en desarrollo')),
    );
  }

  void _deleteComment(Comment comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Comentario'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar este comentario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementar eliminación real
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Comentario eliminado'),
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

  void _replyToComment(Comment comment) {
    // TODO: Implementar respuesta a comentarios
    _commentController.text = '@${comment.createdBy} ';
    _commentFocusNode.requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de respuesta en desarrollo')),
    );
  }
}
