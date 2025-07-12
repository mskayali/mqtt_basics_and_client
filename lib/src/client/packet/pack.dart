
import 'dart:typed_data';

import '../../core/constants.dart';
import '../../core/exceptions/protocol_exception.dart';
import '../../utils/pack_tool.dart';

/// Handles serialization of MQTT packets to binary format.
class Pack {
  static Uint8List connect(Map<String, dynamic> data) {
    final protocolName = data['protocol_name'] ?? mqttProtocolName;
    final protocolLevel = data['protocol_level'] ?? mqttProtocolLevel311;
    final buffer = BytesBuilder();

    buffer.add(PackTool.encodeString(protocolName));
    buffer.addByte(protocolLevel);

    int connectFlags = 0;
    if (data['clean_session'] == true) connectFlags |= (1 << 1);
    if (data['will'] != null) {
      connectFlags |= (1 << 2);
      final will = data['will'];
      final qos = will['qos'] ?? mqttQos0;
      if (qos > mqttQos2) {
        throw ProtocolException('QoS for Will message exceeds maximum value');
      }
      connectFlags |= (qos << 3);
      if (will['retain'] == true) connectFlags |= (1 << 5);
    }
    if (data.containsKey('user_name')) connectFlags |= (1 << 7);
    if (data.containsKey('password')) connectFlags |= (1 << 6);

    buffer.addByte(connectFlags);
    return buffer.toBytes();
  }

static Uint8List will(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final topic = buffer['topic'] ?? '';
    final message = buffer['message'] ?? '';
    final props = buffer['properties'] ?? {};

    builder.add(PackTool.encodeString(topic));
    builder.add(PackTool.encodeString(message));

    if (props.isNotEmpty) {
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }

static Uint8List unsubAck(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final messageId = buffer['message_id'] ?? 0;
    final codes = buffer['codes'] ?? <int>[];
    final props = buffer['properties'] ?? {};

    builder.addByte((messageId >> 8) & 0xFF); // MSB
    builder.addByte(messageId & 0xFF); // LSB

    if (props.isNotEmpty) {
      builder.add(PackTool.encodeProperties(props));
    }

    for (final code in codes) {
      builder.addByte(code);
    }

    return builder.toBytes();
  }


static Uint8List subAck(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final messageId = buffer['message_id'] ?? 0;
    final codes = buffer['codes'] ?? <int>[];
    final props = buffer['properties'] ?? {};

    builder.addByte((messageId >> 8) & 0xFF); // MSB
    builder.addByte(messageId & 0xFF); // LSB

    if (props.isNotEmpty) {
      builder.add(PackTool.encodeProperties(props));
    }

    for (final code in codes) {
      builder.addByte(code);
    }

    return builder.toBytes();
  }


static Uint8List pubRel(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final messageId = buffer['message_id'] ?? 0;
    final code = buffer['code'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.addByte((messageId >> 8) & 0xFF);
    builder.addByte(messageId & 0xFF);

    // MQTT 5.0 fields
    if (props.isNotEmpty || code != 0) {
      builder.addByte(code);
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }


static Uint8List pubRec(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final messageId = buffer['message_id'] ?? 0;
    final code = buffer['code'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.addByte((messageId >> 8) & 0xFF);
    builder.addByte(messageId & 0xFF);

    if (props.isNotEmpty || code != 0) {
      builder.addByte(code);
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }


static Uint8List publish(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final topic = buffer['topic'] ?? '';
    final message = buffer['message'] ?? '';
    final qos = buffer['qos'] ?? 0;
    final messageId = buffer['message_id'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.add(PackTool.encodeString(topic));

    if (qos > 0) {
      builder.addByte((messageId >> 8) & 0xFF);
      builder.addByte(messageId & 0xFF);
    }

    if (props.isNotEmpty) {
      builder.add(PackTool.encodeProperties(props));
    }

    builder.add(PackTool.encodeString(message)); // or encodeBinary if binary payload is supported

    return builder.toBytes();
  }


static Uint8List pubComp(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final messageId = buffer['message_id'] ?? 0;
    final code = buffer['code'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.addByte((messageId >> 8) & 0xFF);
    builder.addByte(messageId & 0xFF);

    if (props.isNotEmpty || code != 0) {
      builder.addByte(code);
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }


static Uint8List pubAck(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final messageId = buffer['message_id'] ?? 0;
    final code = buffer['code'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.addByte((messageId >> 8) & 0xFF);
    builder.addByte(messageId & 0xFF);

    if (props.isNotEmpty || code != 0) {
      builder.addByte(code);
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }


static Uint8List pingResp(Map<String, dynamic> buffer) {
    // Fixed header for PINGRESP: type (0xD0), remaining length (0)
    return Uint8List.fromList([0xD0, 0x00]);
  }


static Uint8List disconnect(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final code = buffer['code'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.addByte(code);

    if (props.isNotEmpty) {
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }


static Uint8List connAck(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final sessionPresent = buffer['session_present'] ?? 0;
    final code = buffer['code'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.addByte(sessionPresent & 0x01); // Only 1 bit used
    builder.addByte(code);

    if (props.isNotEmpty) {
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }


static Uint8List auth(Map<String, dynamic> buffer) {
    final builder = BytesBuilder();

    final code = buffer['code'] ?? 0;
    final props = buffer['properties'] ?? {};

    builder.addByte(code);

    if (props.isNotEmpty) {
      builder.add(PackTool.encodeProperties(props));
    }

    return builder.toBytes();
  }

}
