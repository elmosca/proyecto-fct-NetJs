import 'package:fct_frontend/core/utils/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Servicio para manejar notificaciones push y locales
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Inicializa el servicio de notificaciones
  Future<void> initialize() async {
    try {
      Logger.info('Inicializando servicio de notificaciones');

      // Configuración para Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración para iOS
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Configuración general
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Inicializar el plugin
      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      Logger.success('Servicio de notificaciones inicializado correctamente');
    } catch (e) {
      Logger.error('Error inicializando servicio de notificaciones: $e');
    }
  }

  /// Configura los canales de notificación para Android
  Future<void> setupNotificationChannels() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'Notificaciones Importantes',
        description: 'Canal para notificaciones importantes del sistema',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      const AndroidNotificationChannel generalChannel =
          AndroidNotificationChannel(
        'general_channel',
        'Notificaciones Generales',
        description: 'Canal para notificaciones generales',
        importance: Importance.defaultImportance,
        playSound: true,
        enableVibration: false,
        showBadge: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(generalChannel);

      Logger.info('Canales de notificación configurados');
    } catch (e) {
      Logger.error('Error configurando canales de notificación: $e');
    }
  }

  /// Solicita permisos de notificación
  Future<bool> requestPermissions() async {
    try {
      // En versiones más recientes, los permisos se solicitan automáticamente
      // Retornamos true por defecto
      return true;
    } catch (e) {
      Logger.error('Error solicitando permisos de notificación: $e');
      return false;
    }
  }

  /// Muestra una notificación local
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.general,
    int id = 0,
  }) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        _getChannelId(type),
        _getChannelName(type),
        channelDescription: _getChannelDescription(type),
        importance: _getImportance(type),
        priority: _getPriority(type),
        icon: _getIcon(type),
        enableVibration: type == NotificationType.important,
        playSound: true,
        showWhen: true,
      );

      const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      Logger.info('Notificación mostrada: $title');
    } catch (e) {
      Logger.error('Error mostrando notificación: $e');
    }
  }

  /// Cancela una notificación específica
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      Logger.info('Notificación cancelada: $id');
    } catch (e) {
      Logger.error('Error cancelando notificación: $e');
    }
  }

  /// Cancela todas las notificaciones
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      Logger.info('Todas las notificaciones canceladas');
    } catch (e) {
      Logger.error('Error cancelando todas las notificaciones: $e');
    }
  }

  /// Obtiene las notificaciones pendientes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _localNotifications.pendingNotificationRequests();
    } catch (e) {
      Logger.error('Error obteniendo notificaciones pendientes: $e');
      return [];
    }
  }

  /// Maneja el tap en una notificación
  void _onNotificationTapped(NotificationResponse response) {
    Logger.info('Notificación tocada: ${response.payload}');

    // TODO: Implementar navegación basada en el payload
    if (response.payload != null) {
      // Navegar a la pantalla correspondiente
    }
  }

  /// Obtiene el ID del canal según el tipo de notificación
  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.important:
        return 'high_importance_channel';
      case NotificationType.general:
      default:
        return 'general_channel';
    }
  }

  /// Obtiene el nombre del canal según el tipo de notificación
  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.important:
        return 'Notificaciones Importantes';
      case NotificationType.general:
      default:
        return 'Notificaciones Generales';
    }
  }

  /// Obtiene la descripción del canal según el tipo de notificación
  String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.important:
        return 'Canal para notificaciones importantes del sistema';
      case NotificationType.general:
      default:
        return 'Canal para notificaciones generales';
    }
  }

  /// Obtiene la importancia según el tipo de notificación
  Importance _getImportance(NotificationType type) {
    switch (type) {
      case NotificationType.important:
        return Importance.high;
      case NotificationType.general:
      default:
        return Importance.defaultImportance;
    }
  }

  /// Obtiene la prioridad según el tipo de notificación
  Priority _getPriority(NotificationType type) {
    switch (type) {
      case NotificationType.important:
        return Priority.high;
      case NotificationType.general:
      default:
        return Priority.defaultPriority;
    }
  }

  /// Obtiene el icono según el tipo de notificación
  String _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.important:
        return '@mipmap/ic_launcher';
      case NotificationType.general:
      default:
        return '@mipmap/ic_launcher';
    }
  }
}

/// Tipos de notificación
enum NotificationType {
  general,
  important,
}
