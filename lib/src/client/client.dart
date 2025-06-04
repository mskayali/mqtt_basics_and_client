
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/base_client.dart';
import 'package:mqtt_basics_and_client/src/core/config/client_config.dart';

/// Main TCP-based MQTT client.
/// Handles creation and configuration of the socket based on client settings.
class Client extends BaseClient {
  final ClientConfig config;
  final int clientType;

  Socket? _socket;

  Client(String host, int port, this.config, {this.clientType = BaseClient.coroutineClientType}) {
    super.host=host;
    super.port = port;
  }

  /// Connects the client to the MQTT broker
  Future<void> connect() async {
    _socket = await Socket.connect(host, port);
    // Configure the socket if needed using `config.swooleConfig`
    super.client = _socket;
  }

  /// Returns the internal socket/client
  @override
  Socket? getClient() => _socket;

  /// Sends binary data through the socket
  @override
  void send(Uint8List data) {
    _socket?.add(data);
  }

  /// Receives data from the socket
  @override
  Future<Uint8List> receive() async {
    final completer = Completer<Uint8List>();
    final buffer = BytesBuilder();

    _socket?.listen(
      (data) {
        buffer.add(data);
        completer.complete(buffer.toBytes());
      },
      onError: completer.completeError,
    );

    return completer.future;
  }

  /// Checks if the client is a coroutine-style (non-blocking) client
  bool isCoroutineClientType() => clientType == BaseClient.coroutineClientType;
}
