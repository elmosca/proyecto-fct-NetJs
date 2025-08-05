import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:fct_frontend/core/extensions/color_extensions.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onSelectionChanged,
  });

  final UserEntity user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final bool isSelected;
  final bool isSelectionMode;
  final Function(String)? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: isSelectionMode
            ? Checkbox(
                value: isSelected,
                onChanged: (value) {
                  onSelectionChanged?.call(user.id);
                },
              )
            : CircleAvatar(
                backgroundColor: _getRoleColor(user.role),
                child: Text(
                  _getInitials(user.firstName, user.lastName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getRoleDisplayName(user.role),
                    style: TextStyle(
                      color: _getRoleColor(user.role),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (user.isActive ?? true)
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (user.isActive ?? true) ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color:
                          (user.isActive ?? true) ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: isSelectionMode
            ? null
            : PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'toggle':
                      onToggleStatus();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(Icons.toggle_on, size: 20),
                        SizedBox(width: 8),
                        Text('Cambiar estado'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'tutor':
        return Colors.blue;
      case 'colaborador':
        return Colors.orange;
      case 'alumno':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrador';
      case 'tutor':
        return 'Tutor';
      case 'colaborador':
        return 'Colaborador';
      case 'alumno':
        return 'Alumno';
      default:
        return role;
    }
  }
}
