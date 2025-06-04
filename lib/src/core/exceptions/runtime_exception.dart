
/// Thrown when a general MQTT runtime error occurs.
class RuntimeException implements Exception {
  final String message;

  RuntimeException([this.message = 'Runtime exception occurred']);

  @override
  String toString() => 'RuntimeException: $message';
}
