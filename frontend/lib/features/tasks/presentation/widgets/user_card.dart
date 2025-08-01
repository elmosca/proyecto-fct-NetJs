import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;
  final bool isSelected;
  final bool isAssigned;
  final VoidCallback? onTap;
  final VoidCallback? onAssign;
  final VoidCallback? onUnassign;

  const UserCard({
    super.key,
    required this.user,
    this.isSelected = false,
    this.isAssigned = false,
    this.onTap,
    this.onAssign,
    this.onUnassign,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar del usuario
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _getInitials(user.firstName, user.lastName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Información del usuario
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    _buildRoleChip(context, user.role, l10n),
                  ],
                ),
              ),

              // Botones de acción
              if (onAssign != null || onUnassign != null) ...[
                const SizedBox(width: 8),
                if (isAssigned && onUnassign != null)
                  IconButton(
                    onPressed: onUnassign,
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    tooltip: l10n.unassignUser,
                  )
                else if (!isAssigned && onAssign != null)
                  IconButton(
                    onPressed: onAssign,
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.green),
                    tooltip: l10n.assignUser,
                  ),
              ],

              // Indicador de selección
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(
      BuildContext context, String role, AppLocalizations l10n) {
    Color chipColor;
    String roleText;

    switch (role.toLowerCase()) {
      case 'student':
        chipColor = Colors.blue;
        roleText = l10n.student;
        break;
      case 'tutor':
        chipColor = Colors.orange;
        roleText = l10n.tutor;
        break;
      case 'admin':
        chipColor = Colors.red;
        roleText = l10n.admin;
        break;
      default:
        chipColor = Colors.grey;
        roleText = role;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: chipColor,
          width: 1,
        ),
      ),
      child: Text(
        roleText,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }
}
