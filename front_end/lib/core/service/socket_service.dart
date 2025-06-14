import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  IO.Socket? _socket;
  bool _isInitialized = false;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    _initializeSocket();
  }

  IO.Socket get socket {
    if (_socket == null) {
      throw Exception('Socket not initialized. Call ensureInitialized first.');
    }
    return _socket!;
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeSocket();
    }
  }

  Future<void> _initializeSocket() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token_key") ?? '';

      _socket = IO.io(
        'http://192.168.248.220:8000', // Replace with your backend URL
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .build(),
      );

      _socket!.connect();

      _socket!.onConnect((_) {
        print('Socket connected: ${_socket!.id}');
        _isInitialized = true;
      });

      _socket!.onConnectError((error) {
        print('Socket connection error: $error');
        _isInitialized = false;
      });

      _socket!.onDisconnect((_) {
        print('Socket disconnected');
        _isInitialized = false;
      });

      // Wait for connection or timeout
      await Future.any([
        Future.delayed(const Duration(seconds: 5)),
        Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return !_isInitialized && _socket!.connected;
        }),
      ]);

      if (!_socket!.connected) {
        print('Socket connection timed out');
      }
    } catch (e) {
      print('Socket initialization error: $e');
      _isInitialized = false;
    }
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _isInitialized = false;
  }
}