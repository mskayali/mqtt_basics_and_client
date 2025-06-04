
/// Thrown when an MQTT connection fails.
class ConnectException implements Exception {
  final String message;

  ConnectException([this.message = 'MQTT connection failed']);

  @override
  String toString() => 'ConnectException: $message';
}
