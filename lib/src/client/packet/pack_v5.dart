
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/properties/pack_property.dart';
import 'package:mqtt_basics_and_client/src/core/constants.dart';
import 'package:mqtt_basics_and_client/src/core/exceptions/protocol_exception.dart';
import 'package:mqtt_basics_and_client/src/utils/pack_tool.dart';

/// MQTT v5 packet encoder. Focuses on CONNECT packet logic.
class PackV5 {
  /// Encodes a CONNECT packet for MQTT version 5 clients
  static Uint8List connect(Map<String, dynamic> data) {
    final protocolName = data['protocol_name'] ?? mqttProtocolName;
    final protocolLevel = data['protocol_level'] ?? mqttProtocolLevel50;

    final buffer = BytesBuilder();

    // Protocol name and version
    buffer.add(PackTool.encodeString(protocolName));
    buffer.addByte(protocolLevel);

    // Connect flags
    int connectFlags = 0;
    if (data['clean_session'] == true) {
      connectFlags |= (1 << 1);
    }

    if (data['will'] != null) {
      final will = data['will'];
      connectFlags |= (1 << 2);
      final qos = will['qos'] ?? mqttQos0;
      if (qos > mqttQos2) {
        throw ProtocolException('Will QoS exceeds allowed range');
      }
      connectFlags |= (qos << 3);
      if (will['retain'] == true) {
        connectFlags |= (1 << 5);
      }
    }

    if (data.containsKey('password')) {
      connectFlags |= (1 << 6);
    }

    if (data.containsKey('user_name')) {
      connectFlags |= (1 << 7);
    }

    buffer.addByte(connectFlags);

    // Keep Alive
    buffer.add(PackTool.encodeInt16(data['keep_alive'] ?? 0));

    // Add CONNECT properties
    final properties = data['properties'] ?? <String, dynamic>{};
    buffer.add(PackProperty.encode(properties));

    // Additional payload steps like client ID, will, username, and password are required

    return buffer.toBytes(); // This is a partial implementation
  }
}
