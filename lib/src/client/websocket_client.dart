
import 'dart:convert';
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/base_client.dart';
import 'package:mqtt_basics_and_client/src/core/config/client_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// MQTT client that connects using WebSocket.
/// Provides MQTT over WebSocket support, configurable with path and SSL.
class WebSocketClient extends BaseClient {
  final ClientConfig config;
  final String path;
  final bool ssl;

  late WebSocketChannel _channel;

  WebSocketClient(
    String host,
    int port,
    this.config, {
    this.path = '/mqtt',
    this.ssl = false,
  }) {
    super.host = host;
    super.port = port;
    _connect();
  }

  /// Initializes the WebSocket channel connection
  void _connect() {
    final uri = Uri(
      scheme: ssl ? 'wss' : 'ws',
      host: host,
      port: port,
      path: path,
    );
    _channel = WebSocketChannel.connect(uri);
    super.client = _channel;
  }

  /// Returns the WebSocket channel
  @override
  WebSocketChannel getClient() => _channel;

  /// Sends binary data over WebSocket
  @override
  void send(Uint8List data) {
    _channel.sink.add(data);
  }

  /// Receives binary data from WebSocket
  @override
  Future<Uint8List> receive() async {
    final data = await _channel.stream.first;
    if (data is String) {
      return Uint8List.fromList(utf8.encode(data));
    } else if (data is List<int>) {
      return Uint8List.fromList(data);
    } else {
      throw FormatException('Unsupported WebSocket data type');
    }
  }
}
