import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/auth/presentation/providers/auth_providers.dart';
import 'package:fct_frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context, authState),
          _buildDrawerItems(context),
          const Divider(),
          _buildDrawerFooter(context, ref),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
      BuildContext context, AsyncValue<AuthState> authState) {
    return authState.when(
      data: (state) => state.when(
        authenticated: (user) => UserAccountsDrawerHeader(
          accountName: Text('${user.firstName} ${user.lastName}'),
          accountEmail: Text(user.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        unauthenticated: () => const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'FCT - Gestión de Proyectos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        initial: () => const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Cargando...', style: TextStyle(color: Colors.white)),
        ),
        loading: () => const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (message) => DrawerHeader(
          decoration: const BoxDecoration(color: Colors.red),
          child: Text('Error: $message',
              style: const TextStyle(color: Colors.white)),
        ),
      ),
      loading: () => const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, stack) => DrawerHeader(
        decoration: const BoxDecoration(color: Colors.red),
        child:
            Text('Error: $error', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDrawerItems(BuildContext context) {
    return Column(
      children: [
        _buildDrawerItem(
          context,
          icon: Icons.dashboard,
          title: AppLocalizations.of(context)!.dashboard,
          route: '/app/dashboard',
        ),
        _buildDrawerItem(
          context,
          icon: Icons.work,
          title: AppLocalizations.of(context)!.projects,
          route: '/app/projects',
        ),
        _buildDrawerItem(
          context,
          icon: Icons.task,
          title: AppLocalizations.of(context)!.tasks,
          route: '/app/tasks',
        ),
        _buildDrawerItem(
          context,
          icon: Icons.people,
          title: AppLocalizations.of(context)!.users,
          route: '/app/users',
        ),
        const Divider(),
        _buildDrawerItem(
          context,
          icon: Icons.person,
          title: AppLocalizations.of(context)!.profile,
          route: '/app/profile',
        ),
        _buildDrawerItem(
          context,
          icon: Icons.settings,
          title: AppLocalizations.of(context)!.settings,
          route: '/app/settings',
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cerrar drawer
        context.router.pushNamed(route);
      },
    );
  }

  Widget _buildDrawerFooter(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(AppLocalizations.of(context)!.logout),
          onTap: () async {
            Navigator.pop(context);
            await ref.read(authNotifierProvider.notifier).logout();
            if (context.mounted) {
              context.router.replaceNamed('/login');
            }
          },
        ),
      ],
    );
  }
}
