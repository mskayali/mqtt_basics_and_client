
import 'dart:typed_data';

import '../../client/properties/unpack_property.dart';
import '../../utils/unpack_tool.dart';

/// MQTT v5 packet unpacker with support for advanced properties and reason codes.
class UnPackV5 {
  /// Decodes the CONNECT packet contents for MQTT 5
  static Map<String, dynamic> connect(Uint8List data) {
    final buffer = data.buffer.asByteData();
    int offset = 0;

    // Decode protocol name
    final protocolNameResult = UnPackTool.decodeString(data, offset);
    final protocolName = protocolNameResult['value'] as String;
    offset = protocolNameResult['offset'];

    // Protocol level
    final protocolLevel = buffer.getUint8(offset);
    offset += 1;

    // Flags
    final flags = buffer.getUint8(offset);
    offset += 1;

    final cleanSession = (flags >> 1) & 0x01;
    final willFlag = (flags >> 2) & 0x01;
    final willQos = (flags >> 3) & 0x03;
    final willRetain = (flags >> 5) & 0x01;
    final passwordFlag = (flags >> 6) & 0x01;
    final userNameFlag = (flags >> 7) & 0x01;

    // Keep Alive
    final keepAlive = buffer.getUint16(offset);
    offset += 2;

    // Decode properties
    final propertyResult = UnPackProperty.decode(data, offset);
    final properties = propertyResult['properties'] as Map<String, dynamic>;
    offset = propertyResult['offset'] as int;

    // Remaining decoding for client ID, will, username, password to be handled...

    return {
      'protocol_name': protocolName,
      'protocol_level': protocolLevel,
      'clean_session': cleanSession == 1,
      'will_flag': willFlag == 1,
      'will_qos': willQos,
      'will_retain': willRetain == 1,
      'password_flag': passwordFlag == 1,
      'user_name_flag': userNameFlag == 1,
      'keep_alive': keepAlive,
      'properties': properties,
    };
  }
static Map<String, dynamic> connAck(Uint8List data) {
    final buffer = data.buffer.asByteData();
    int offset = 0;

    final sessionPresent = (buffer.getUint8(offset) & 0x01) == 1;
    offset += 1;

    final code = buffer.getUint8(offset);
    offset += 1;

    // Decode properties
    final propertyResult = UnPackProperty.decode(data, offset);
    final properties = propertyResult['properties'] as Map<String, dynamic>;
    offset = propertyResult['offset'] as int;

    return {
      'type': 2, // Types.connAck
      'session_present': sessionPresent,
      'code': code,
      'properties': properties,
    };
  }
static Map<String, dynamic> publish({required int dup, required int qos, required int retain, required Uint8List data}) {
    int offset = 0;

    // Decode topic
    final topicResult = UnPackTool.decodeString(data, offset);
    final topic = topicResult['value'] as String;
    offset = topicResult['offset'] as int;

    int? messageId;
    if (qos > 0) {
      final idResult = UnPackTool.decodeInt16(data, offset);
      messageId = idResult['value'] as int;
      offset = idResult['offset'] as int;
    }

    // Decode properties
    final propertyResult = UnPackProperty.decode(data, offset);
    final properties = propertyResult['properties'] as Map<String, dynamic>;
    offset = propertyResult['offset'] as int;

    // Remaining is the message payload
    final messageBytes = data.sublist(offset);
    final message = String.fromCharCodes(messageBytes);

    final result = {
      'type': 3, // Types.publish
      'dup': dup,
      'qos': qos,
      'retain': retain,
      'topic': topic,
      'message': message,
      'properties': properties,
    };

    if (messageId != null) {
      result['message_id'] = messageId;
    }

    return result;
  }
static Map<String, dynamic> subscribe(Uint8List data) {
    int offset = 0;

    // Decode message ID
    final messageIdResult = UnPackTool.decodeInt16(data, offset);
    final messageId = messageIdResult['value'] as int;
    offset = messageIdResult['offset'] as int;

    // Decode properties
    final propertyResult = UnPackProperty.decode(data, offset);
    final properties = propertyResult['properties'] as Map<String, dynamic>;
    offset = propertyResult['offset'] as int;

    // Decode topics
    final topics = <String, Map<String, dynamic>>{};
    while (offset < data.length) {
      final topicResult = UnPackTool.decodeString(data, offset);
      final topic = topicResult['value'] as String;
      offset = topicResult['offset'] as int;

      final option = data[offset];
      offset += 1;

      topics[topic] = {
        'qos': option & 0x03,
        'no_local': (option >> 2) & 0x01 == 1,
        'retain_as_published': (option >> 3) & 0x01 == 1,
        'retain_handling': (option >> 4),
      };
    }

    return {
      'type': 8, // Types.subscribe
      'message_id': messageId,
      'properties': properties,
      'topics': topics,
    };
  }
static Map<String, dynamic> subAck(Uint8List data) {
    int offset = 0;

    // Decode message ID
    final messageIdResult = UnPackTool.decodeInt16(data, offset);
    final messageId = messageIdResult['value'] as int;
    offset = messageIdResult['offset'] as int;

    // Decode properties
    final propertyResult = UnPackProperty.decode(data, offset);
    final properties = propertyResult['properties'] as Map<String, dynamic>;
    offset = propertyResult['offset'] as int;

    // Decode return codes
    final codes = <int>[];
    while (offset < data.length) {
      codes.add(data[offset]);
      offset += 1;
    }

    return {
      'type': 9, // Types.subAck
      'message_id': messageId,
      'properties': properties,
      'codes': codes,
    };
  }
static Map<String, dynamic> unSubscribe(Uint8List data) {
    int offset = 0;

    // Decode message ID
    final messageIdResult = UnPackTool.decodeInt16(data, offset);
    final messageId = messageIdResult['value'] as int;
    offset = messageIdResult['offset'] as int;

    // Decode properties
    final propertyResult = UnPackProperty.decode(data, offset);
    final properties = propertyResult['properties'] as Map<String, dynamic>;
    offset = propertyResult['offset'] as int;

    // Decode topics
    final topics = <String>[];
    while (offset < data.length) {
      final topicResult = UnPackTool.decodeString(data, offset);
      final topic = topicResult['value'] as String;
      offset = topicResult['offset'] as int;
      topics.add(topic);
    }

    return {
      'type': 10, // Types.unSubscribe
      'message_id': messageId,
      'properties': properties,
      'topics': topics,
    };
  }
static Map<String, dynamic> unSubAck(Uint8List data) {
    int offset = 0;

    // Decode message ID
    final messageIdResult = UnPackTool.decodeInt16(data, offset);
    final messageId = messageIdResult['value'] as int;
    offset = messageIdResult['offset'] as int;

    // Decode properties
    final propertyResult = UnPackProperty.decode(data, offset);
    final properties = propertyResult['properties'] as Map<String, dynamic>;
    offset = propertyResult['offset'] as int;

    // Decode reason codes
    final codes = <int>[];
    while (offset < data.length) {
      codes.add(data[offset]);
      offset++;
    }

    return {
      'type': 11, // Types.unSubAck
      'message_id': messageId,
      'properties': properties,
      'codes': codes,
    };
  }
static Map<String, dynamic> disconnect(Uint8List data) {
    int offset = 0;
    int code = 0;
    Map<String, dynamic> properties = {};

    // Check if reason code is present
    if (offset < data.length) {
      code = data[offset];
      offset += 1;
    }

    // Check if properties are present
    if (offset < data.length) {
      final propertyResult = UnPackProperty.decode(data, offset);
      properties = propertyResult['properties'] as Map<String, dynamic>;
      offset = propertyResult['offset'] as int;
    }

    return {
      'type': 14, // Types.disconnect
      'code': code,
      if (properties.isNotEmpty) 'properties': properties,
    };
  }
static Map<String, dynamic> getReasonCode(int type, Uint8List data) {
    int offset = 0;

    // Decode message ID
    final messageId = UnPackTool.decodeInt16(data, offset);
    offset += 2;

    // Default reason code is SUCCESS (0)
    int code = 0;
    if (offset < data.length) {
      code = data[offset];
      offset += 1;
    }

    Map<String, dynamic> properties = {};
    if (offset < data.length) {
      final propertyResult = UnPackProperty.decode(data, offset);
      properties = propertyResult['properties'] as Map<String, dynamic>;
      offset = propertyResult['offset'] as int;
    }

    return {'type': type, 'message_id': messageId, 'code': code, if (properties.isNotEmpty) 'properties': properties};
  }
static Map<String, dynamic> auth(Uint8List data) {
    int offset = 0;

    // Default reason code is SUCCESS (0)
    int code = 0;
    if (offset < data.length) {
      code = data[offset];
      offset += 1;
    }

    Map<String, dynamic> properties = {};
    if (offset < data.length) {
      final propertyResult = UnPackProperty.decode(data, offset);
      properties = propertyResult['properties'] as Map<String, dynamic>;
      offset = propertyResult['offset'] as int;
    }

    return {
      'type': 15, // MQTT Control Packet type for AUTH
      'code': code,
      if (properties.isNotEmpty) 'properties': properties,
    };
  }

}
