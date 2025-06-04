
/// Thrown when an MQTT protocol rule is violated.
class ProtocolException implements Exception {
  final String message;

  ProtocolException([this.message = 'MQTT protocol error']);

  @override
  String toString() => 'ProtocolException: $message';
}
