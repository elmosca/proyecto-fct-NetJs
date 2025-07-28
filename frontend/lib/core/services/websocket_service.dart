import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fct_frontend/core/utils/logger.dart';

class WebSocketService {
  WebSocketService({required WebSocketChannel channel}) : _channel = channel {
    _initialize();
  }
  final WebSocketChannel _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  Timer? _pingTimer;
  bool _isConnected = false;

  void _initialize() {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();

    _channel.stream.listen(
      (data) {
        Logger.info('🔌 WebSocket received: $data');
        if (data is Map<String, dynamic>) {
          _messageController?.add(data);
        }
      },
      onError: (error) {
        Logger.error('❌ WebSocket error: $error');
        _isConnected = false;
      },
      onDone: () {
        Logger.info('🔌 WebSocket connection closed');
        _isConnected = false;
      },
    );

    _startPingTimer();
    _isConnected = true;
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
      Logger.info('🔌 WebSocket sending: $message');
      _channel.sink.add(message);
    } else {
      Logger.warning('⚠️ WebSocket not connected, cannot send message');
    }
  }

  void close() {
    _pingTimer?.cancel();
    _messageController?.close();
    _channel.sink.close();
    _isConnected = false;
  }

  void reconnect() {
    close();
    _initialize();
  }
}
