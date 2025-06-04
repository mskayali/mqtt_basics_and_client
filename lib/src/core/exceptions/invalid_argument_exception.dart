
/// Thrown when an invalid argument is provided to an MQTT operation.
class InvalidArgumentException implements Exception {
  final String message;

  InvalidArgumentException([this.message = 'Invalid argument']);

  @override
  String toString() => 'InvalidArgumentException: $message';
}
