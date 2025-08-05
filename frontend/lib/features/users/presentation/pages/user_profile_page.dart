import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/auth/presentation/providers/auth_providers.dart';
import 'package:fct_frontend/features/users/domain/entities/role_enum.dart';
import 'package:fct_frontend/features/users/presentation/widgets/change_password_dialog.dart';
import 'package:fct_frontend/features/users/presentation/widgets/profile_form.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navegar a configuración
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Configuración en desarrollo'),
                ),
              );
            },
          ),
        ],
      ),
      body: authState.when(
        data: (authState) {
          final user = authState.maybeWhen(
            authenticated: (user) => user,
            orElse: () => null,
          );

          if (user == null) {
            return const Center(
              child: Text('Usuario no autenticado'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del perfil
                _buildProfileHeader(context, user),

                const SizedBox(height: 24),

                // Información del usuario
                _buildUserInfo(context, user),

                const SizedBox(height: 24),

                // Formulario de edición
                ProfileForm(user: user),

                const SizedBox(height: 24),

                // Acciones adicionales
                _buildAdditionalActions(context, user),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar del usuario
            CircleAvatar(
              radius: 40,
              backgroundColor: _getRoleColor(user.role),
              child: Text(
                _getInitials(user.firstName, user.lastName),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Información básica
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.role).withOpacity(0.2),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información de la cuenta',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('ID de usuario', user.id),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Nombre', user.firstName),
            _buildInfoRow('Apellidos', user.lastName),
            _buildInfoRow('Rol', _getRoleDisplayName(user.role)),
            if (user.createdAt != null)
              _buildInfoRow('Fecha de registro', _formatDate(user.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalActions(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Cambiar contraseña'),
              subtitle: const Text('Actualizar tu contraseña de acceso'),
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Preferencias de notificaciones'),
              subtitle: const Text('Configurar alertas y notificaciones'),
              onTap: () {
                // TODO: Implementar preferencias de notificaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preferencias en desarrollo'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text('Idioma'),
              subtitle: const Text('Cambiar idioma de la aplicación'),
              onTap: () {
                // TODO: Implementar selector de idioma
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Selector de idioma en desarrollo'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security_outlined),
              title: const Text('Seguridad'),
              subtitle: const Text('Configuraciones de seguridad'),
              onTap: () {
                // TODO: Implementar configuraciones de seguridad
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuraciones de seguridad en desarrollo'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  String _getInitials(String firstName, String lastName) {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  Color _getRoleColor(String role) {
    final roleEnum = RoleEnum.fromString(role);
    switch (roleEnum) {
      case RoleEnum.admin:
        return Colors.red;
      case RoleEnum.tutor:
        return Colors.blue;
      case RoleEnum.student:
        return Colors.green;
    }
  }

  String _getRoleDisplayName(String role) {
    final roleEnum = RoleEnum.fromString(role);
    return roleEnum.displayName;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No disponible';
    return '${date.day}/${date.month}/${date.year}';
  }
}
