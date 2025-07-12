
import 'dart:typed_data';

import '../../utils/unpack_tool.dart';

/// MQTT packet unpacker for decoding received binary payloads.
class UnPack {
  /// Parses a CONNECT packet and extracts relevant connection fields
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

    // Connect flags
    final flags = buffer.getUint8(offset);
    offset += 1;

    final cleanSession = (flags >> 1) & 0x1;
    final willFlag = (flags >> 2) & 0x1;
    final willQos = (flags >> 3) & 0x3;
    final willRetain = (flags >> 5) & 0x1;
    final passwordFlag = (flags >> 6) & 0x1;
    final userNameFlag = (flags >> 7) & 0x1;

    // Keep Alive (2 bytes)
    final keepAlive = buffer.getUint16(offset);
    offset += 2;

    // Remaining payload decoding such as Client ID, Will, Username, Password would follow here...

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
    };
  }

    /// Parses a CONNACK packet and extracts session and return code
  static Map<String, dynamic> connAck(Uint8List data) {
    final buffer = data.buffer.asByteData();

    final sessionPresent = buffer.getUint8(0) & 0x01;
    final code = buffer.getUint8(1);

    return {
      'type': 2, // Types.connAck
      'session_present': sessionPresent,
      'code': code,
    };
  }
  /// Parses a PUBLISH packet and extracts topic, QoS, retain, message, and optionally message ID
  static Map<String, dynamic> publish(int dup, int qos, int retain, Uint8List data) {
    int offset = 0;

    // Decode topic
    final topicResult = UnPackTool.decodeString(data, offset);
    final topic = topicResult['value'] as String;
    offset = topicResult['offset'] as int;

    int? messageId;
    if (qos > 0) {
      messageId = UnPackTool.decodeInt16(data, offset)['value'];
      offset += 2;
    }

    // Remaining bytes are the payload message
    final messageBytes = data.sublist(offset);
    final message = String.fromCharCodes(messageBytes);

    final result = {
      'type': 3, // Types.publish
      'dup': dup,
      'qos': qos,
      'retain': retain,
      'topic': topic,
      'message': message,
    };

    if (messageId != null) {
      result['message_id'] = messageId;
    }

    return result;
  }
  /// Parses a SUBSCRIBE packet and extracts message ID and topic subscriptions with QoS
  static Map<String, dynamic> subscribe(Uint8List data) {
    int offset = 0;

    // Message ID
    final messageId = UnPackTool.decodeInt16(data, offset);
    offset += 2;

    final topics = <String, int>{};

    while (offset < data.length) {
      final topicResult = UnPackTool.decodeString(data, offset);
      final topic = topicResult['value'] as String;
      offset = topicResult['offset'] as int;

      final qos = data[offset];
      offset += 1;

      topics[topic] = qos;
    }

    return {
      'type': 8, // Types.subscribe
      'message_id': messageId,
      'topics': topics,
    };
  }
  /// Parses a SUBACK packet to extract message ID and return codes
  static Map<String, dynamic> subAck(Uint8List data) {
    int offset = 0;

    // Message ID
    final messageId = UnPackTool.decodeInt16(data, offset);
    offset += 2;

    // Return codes
    final codes = <int>[];
    while (offset < data.length) {
      codes.add(data[offset]);
      offset += 1;
    }

    return {
      'type': 9, // Types.subAck
      'message_id': messageId,
      'codes': codes,
    };
  }
  /// Parses an UNSUBSCRIBE packet to extract message ID and topic list
  static Map<String, dynamic> unSubscribe(Uint8List data) {
    int offset = 0;

    // Message ID
    final messageId = UnPackTool.decodeInt16(data, offset);
    offset += 2;

    // Topics
    final topics = <String>[];
    while (offset < data.length) {
      final result = UnPackTool.decodeString(data, offset);
      topics.add(result['value'] as String);
      offset = result['offset'] as int;
    }

    return {
      'type': 10, // Types.unSubscribe
      'message_id': messageId,
      'topics': topics,
    };
  }

}
