
/// Thrown when an MQTT message or payload exceeds allowed length.
class LengthException implements Exception {
  final String message;

  LengthException([this.message = 'Invalid length encountered']);

  @override
  String toString() => 'LengthException: $message';
}
