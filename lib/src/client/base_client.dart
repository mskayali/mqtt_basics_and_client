
// Base class for MQTT clients, providing connection setup and packet handling
// Originally ported from the Simps MQTT PHP client.
import 'dart:typed_data';

abstract class BaseClient {
  static const int coroutineClientType = 1;
  static const int syncClientType = 2;
  static const int websocketClientType = 3;

  dynamic client; // Underlying client (TCP/WebSocket/etc.)
  int _messageId = 0;

  late String host;
  late int port;


  /// Returns the next MQTT message ID, rolling over after 65535
  int getMessageId() {
    _messageId++;
    if (_messageId > 65535) {
      _messageId = 1;
    }
    return _messageId;
  }

  /// Hint: This should return the client's internal socket or stream.
  dynamic getClient();

  /// Hint: This should handle actual data sending (abstract)
  void send(Uint8List data);

  /// Hint: This should handle receiving data (abstract)
  Future<Uint8List> receive();
}
