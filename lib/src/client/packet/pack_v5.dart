
import 'dart:typed_data';

import '../../client/properties/pack_property.dart';
import '../../core/constants.dart';
import '../../core/exceptions/protocol_exception.dart';
import '../../core/hex/reason_code.dart';
import '../../utils/pack_tool.dart';

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

  /// Encodes a CONNACK packet for MQTT 5.0 clients
  static Uint8List connAck(Map<String, dynamic> data) {
    final buffer = BytesBuilder();

    // Session Present Flag
    final sessionPresent = (data['session_present'] ?? false) ? 1 : 0;
    buffer.addByte(sessionPresent);

    // Reason Code
    final code = data['code'] ?? 0;
    buffer.addByte(code);

    // Properties
    final props = data['properties'] ?? <String, dynamic>{};
    buffer.add(PackProperty.encode(props));

    return buffer.toBytes(); // Final encoded body; fixed header is expected elsewhere
  }
  /// Encodes a PUBLISH packet for MQTT 5.0
  static Uint8List publish(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Topic
    builder.add(PackTool.encodeString(data['topic']));

    // QoS
    final qos = data['qos'] ?? 0;
    if (qos > 0) {
      builder.add(PackTool.encodeInt16(data['message_id']));
    }

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    // Payload
    final message = data['message'];
    if (message is String) {
      builder.add(Uint8List.fromList(message.codeUnits));
    } else if (message is Uint8List) {
      builder.add(message);
    }

    return builder.toBytes(); // Body only, header handled separately
  }
  /// Encodes a SUBSCRIBE packet for MQTT 5.0
  static Uint8List subscribe(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Message ID
    builder.add(PackTool.encodeInt16(data['message_id']));

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    // Topics
    final topics = data['topics'] as Map<String, dynamic>;
    topics.forEach((topic, options) {
      builder.add(PackTool.encodeString(topic));

      int subscribeOptions = 0;
      if (options['qos'] != null) {
        subscribeOptions |= (options['qos'] as int) & 0x03;
      }
      if (options['no_local'] == true) {
        subscribeOptions |= 1 << 2;
      }
      if (options['retain_as_published'] == true) {
        subscribeOptions |= 1 << 3;
      }
      if (options['retain_handling'] != null) {
        subscribeOptions |= (options['retain_handling'] as int) << 4;
      }

      builder.addByte(subscribeOptions);
    });

    return builder.toBytes(); // Body only, header added separately
  }
  /// Encodes a SUBACK packet for MQTT 5.0
  static Uint8List subAck(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Message ID
    builder.add(PackTool.encodeInt16(data['message_id']));

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    // Return codes
    final codes = data['codes'] as List<int>;
    builder.add(Uint8List.fromList(codes));

    return builder.toBytes(); // Body only
  }
  /// Encodes an UNSUBSCRIBE packet for MQTT 5.0
  static Uint8List unSubscribe(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Message ID
    builder.add(PackTool.encodeInt16(data['message_id']));

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    // Topics
    final topics = data['topics'] as List<String>;
    for (final topic in topics) {
      builder.add(PackTool.encodeString(topic));
    }

    return builder.toBytes(); // Body only
  }
  /// Encodes an UNSUBACK packet for MQTT 5.0
  static Uint8List unSubAck(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Message ID
    builder.add(PackTool.encodeInt16(data['message_id']));

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    // Reason codes
    final codes = data['codes'] as List<int>;
    builder.add(Uint8List.fromList(codes));

    return builder.toBytes(); // Body only
  }
  /// Encodes a DISCONNECT packet for MQTT 5.0
  static Uint8List disconnect(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Reason code
    final code = data['code'] ?? ReasonCode.normalDisconnection;
    builder.addByte(code);

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    return builder.toBytes(); // Body only
  }
  /// Encodes a PUBACK, PUBREC, PUBREL, or PUBCOMP packet with a reason code and properties.
  static Uint8List genReasonPhrase(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Message ID
    builder.add(PackTool.encodeInt16(data['message_id']));

    // Reason code
    final code = data['code'] ?? ReasonCode.success;
    builder.addByte(code);

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    return builder.toBytes(); // Body only
  }
  /// Encodes an AUTH packet for MQTT 5.0
  static Uint8List auth(Map<String, dynamic> data) {
    final builder = BytesBuilder();

    // Reason code
    final code = data['code'] ?? ReasonCode.success;
    builder.addByte(code);

    // Properties
    final properties = data['properties'] ?? <String, dynamic>{};
    builder.add(PackProperty.encode(properties));

    return builder.toBytes(); // Body only
  }

}
