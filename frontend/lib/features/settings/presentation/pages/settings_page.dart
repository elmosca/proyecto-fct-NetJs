import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          _buildAppearanceSection(context, ref),
          _buildLanguageSection(context, ref),
          _buildNotificationSection(context, ref),
          _buildPrivacySection(context, ref),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Apariencia',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            subtitle: const Text('Claro'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implementar selector de tema
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Color de Acento'),
            subtitle: const Text('Azul'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implementar selector de color
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Idioma',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma de la Aplicación'),
            subtitle: Text('Español'),
            trailing: LanguageSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Notificaciones',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notificaciones Push'),
            subtitle: const Text('Recibir notificaciones en tiempo real'),
            value: true,
            onChanged: (value) {
              // TODO: Implementar toggle de notificaciones
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email),
            title: const Text('Notificaciones por Email'),
            subtitle:
                const Text('Recibir notificaciones por correo electrónico'),
            value: false,
            onChanged: (value) {
              // TODO: Implementar toggle de email
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: const Text('Sonidos'),
            subtitle: const Text('Reproducir sonidos en notificaciones'),
            value: true,
            onChanged: (value) {
              // TODO: Implementar toggle de sonidos
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Privacidad y Seguridad',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Cambiar Contraseña'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implementar cambio de contraseña
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Autenticación de Dos Factores'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implementar 2FA
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Eliminar Cuenta'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implementar eliminación de cuenta
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Acerca de',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Versión'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Términos de Servicio'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Mostrar términos de servicio
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Política de Privacidad'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Mostrar política de privacidad
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ayuda y Soporte'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Mostrar ayuda
            },
          ),
        ],
      ),
    );
  }
}
