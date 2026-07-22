import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  final String socketUrl;
  late io.Socket socket;

  SocketService({required this.socketUrl}) {
    _initSocket();
  }

  _initSocket() {


  /*  socket = io(
        'https://tradingblitz.com:0',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
    );*/



    socket = io.io(
      socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
      // <String, dynamic>{
      //   'transports': ['websocket'],
      //   'autoConnect': true,
      //   'reconnection': true,
      // },
    );

    socket.on('connect', (_) => debugPrint('✅ Socket connected'));
    socket.on('disconnect', (_) => debugPrint('❌ Socket disconnected'));
    socket.on('connect_error', (error) => debugPrint('⚠️ Connection Error: $error'));
    socket.on('reconnect_attempt', (_) => debugPrint('🔄 Reconnect attempt'));
  }

  /// Connect manually (if autoConnect is false)
  void connect() {
    if (!socket.connected) {
      socket.connect();
    }
  }

  /// Disconnect socket safely
  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }

  /// Emit event to server
  void emit(String event, dynamic data) {
    if (socket.connected) {
      socket.emit(event, data);
      debugPrint('📤 Emit: [$event] $data');
    } else {
      debugPrint('❌ Emit failed, socket not connected.');
    }
  }

  /// Listen to a socket event
  void on(String event, Function(dynamic data) callback) {
    socket.on(event, (data) {
      debugPrint('📥 Received: [$event] $data');
      callback(data);
    });
  }

  /// Remove a specific event listener
  void off(String event) {
    socket.off(event);
    debugPrint('🧹 Listener removed: $event');
  }

  /// Dispose everything
  void dispose() {
    socket.dispose();
    debugPrint('🛑 Socket disposed');
  }

  /// Check connection status
  bool get isConnected => socket.connected;

  /// Reconnect manually
  void reconnect() {
    debugPrint('🔁 Manually reconnecting...');
    disconnect();
    connect();
  }

// Send event
//   socketService.emit('send_message', {'text': 'Hello'});

// Listen for incoming message
//   socketService.on('receive_message', (data) { print('New message: $data'); });

// Disconnect
//   socketService.disconnect();

// Clean up
//   socketService.dispose();
}
