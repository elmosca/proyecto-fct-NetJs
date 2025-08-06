import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/global_search_widget.dart';
import 'package:fct_frontend/core/widgets/language_selector.dart';
import 'package:fct_frontend/core/widgets/notification_badge_widget.dart';
import 'package:fct_frontend/features/dashboard/presentation/widgets/app_bottom_navigation.dart';
import 'package:fct_frontend/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:fct_frontend/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class MainLayoutPage extends ConsumerWidget {
  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(),
      body: const AutoRouter(),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(),
      body: const AutoRouter(),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const Row(
        children: [
          SizedBox(
            width: 250,
            child: AppDrawer(),
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: AutoRouter(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Sistema FCT'),
      actions: [
        const GlobalSearchWidget(),
        const SizedBox(width: 8),
        const LanguageSelector(),
        const SizedBox(width: 8),
        const NotificationBadgeWidget(),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                context.router.pushNamed('/app/profile');
                break;
              case 'settings':
                context.router.pushNamed('/app/settings');
                break;
              case 'logout':
                // TODO: Implementar logout
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Text('Perfil'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('Configuración'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
