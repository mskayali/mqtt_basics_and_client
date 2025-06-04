
import 'dart:typed_data';

/// Base class for MQTT protocol messages.
/// Holds shared logic like protocol level and property map.
abstract class AbstractMessage {
  int protocolLevel;
  final Map<String, dynamic> properties;

  AbstractMessage({
    this.protocolLevel = 4, // Default to MQTT 3.1.1
    Map<String, dynamic>? properties,
  }) : properties = properties ?? {};

  /// Retrieves the protocol level for this message.
  int getProtocolLevel() {
    if (properties.isNotEmpty && protocolLevel != 5) {
      return 5; // Upgrade if properties are present and not already v5
    }
    return protocolLevel;
  }

  /// Sets a protocol property by key
  void setProperty(String key, dynamic value) {
    properties[key] = value;
  }

  /// Retrieves all message properties
  Map<String, dynamic> getProperties() => properties;

  /// Default abstract method for message content packing
  /// Should be overridden by subclasses to define packet structure.
  Map<String, dynamic> getContents();
  Uint8List getBuffer();
}
