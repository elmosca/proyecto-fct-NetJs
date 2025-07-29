import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/core/utils/logger.dart';

class WebSocketService {
  WebSocketService({
    required WebSocketChannel channel,
    required StorageService storageService,
  })  : _channel = channel,
        _storageService = storageService {
    _initialize();
  }

  final WebSocketChannel _channel;
  final StorageService _storageService;
  StreamController<Map<String, dynamic>>? _messageController;
  StreamController<bool>? _connectionController;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  void _initialize() {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
    _connectionController = StreamController<bool>.broadcast();

    _channel.stream.listen(
      (data) {
        Logger.websocket('Received: $data');
        _handleMessage(data);
      },
      onError: (error) {
        Logger.error('WebSocket error: $error', null, null, 'WEBSOCKET');
        _handleConnectionError(error);
      },
      onDone: () {
        Logger.websocket('Connection closed');
        _handleConnectionClosed();
      },
    );

    _startPingTimer();
    _isConnected = true;
    _connectionController?.add(true);
    Logger.websocket('WebSocket initialized and connected');
  }

  void _startPingTimer() {
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        send({'type': 'ping'});
      }
    });
  }

  Stream<Map<String, dynamic>> get messageStream =>
      _messageController?.stream ?? const Stream.empty();

  bool get isConnected => _isConnected;

  void send(Map<String, dynamic> message) {
    if (_isConnected) {
      Logger.websocket('Sending: $message');
      _channel.sink.add(message);
    } else {
      Logger.warning(
          'WebSocket not connected, cannot send message', 'WEBSOCKET');
    }
  }

  void close() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _messageController?.close();
    _connectionController?.close();
    _channel.sink.close();
    _isConnected = false;
    _reconnectAttempts = 0;
  }

  void reconnect() {
    close();
    _initialize();
  }

  /// Manejar mensajes recibidos
  void _handleMessage(dynamic data) {
    try {
      Map<String, dynamic> message;

      if (data is String) {
        message = jsonDecode(data) as Map<String, dynamic>;
      } else if (data is Map<String, dynamic>) {
        message = data;
      } else {
        Logger.warning('Invalid message format: $data', 'WEBSOCKET');
        return;
      }

      // Manejar diferentes tipos de mensajes
      final type = message['type'] as String?;
      switch (type) {
        case 'pong':
          Logger.websocket('Pong received');
          break;
        case 'notification':
          _handleNotification(message);
          break;
        case 'error':
          _handleError(message);
          break;
        default:
          _messageController?.add(message);
      }
    } catch (e) {
      Logger.error('Error handling message: $e', e, null, 'WEBSOCKET');
    }
  }

  /// Manejar notificaciones
  void _handleNotification(Map<String, dynamic> message) {
    Logger.websocket('Notification received: ${message['data']}');
    _messageController?.add(message);
  }

  /// Manejar errores del WebSocket
  void _handleError(Map<String, dynamic> message) {
    Logger.error('WebSocket error message: ${message['error']}', null, null,
        'WEBSOCKET');
    _messageController?.add(message);
  }

  /// Manejar errores de conexión
  void _handleConnectionError(dynamic error) {
    _isConnected = false;
    _connectionController?.add(false);

    if (_reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    } else {
      Logger.error(
          'Max reconnection attempts reached', null, null, 'WEBSOCKET');
    }
  }

  /// Manejar cierre de conexión
  void _handleConnectionClosed() {
    _isConnected = false;
    _connectionController?.add(false);

    if (_reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    }
  }

  /// Programar reconexión
  void _scheduleReconnect() {
    _reconnectAttempts++;
    Logger.websocket('Scheduling reconnect attempt $_reconnectAttempts');

    _reconnectTimer = Timer(_reconnectDelay, () {
      Logger.websocket('Attempting to reconnect...');
      reconnect();
    });
  }

  /// Stream de estado de conexión
  Stream<bool> get connectionStream =>
      _connectionController?.stream ?? const Stream.empty();

  /// Enviar mensaje con autenticación
  Future<void> sendAuthenticated(Map<String, dynamic> message) async {
    final token = await _storageService.getToken();
    if (token != null) {
      message['token'] = token;
    }
    send(message);
  }

  /// Suscribirse a un canal específico
  void subscribeToChannel(String channel) {
    sendAuthenticated({
      'type': 'subscribe',
      'channel': channel,
    });
  }

  /// Desuscribirse de un canal específico
  void unsubscribeFromChannel(String channel) {
    sendAuthenticated({
      'type': 'unsubscribe',
      'channel': channel,
    });
  }
}
