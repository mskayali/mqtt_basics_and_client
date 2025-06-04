
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/properties/unpack_property.dart';
import 'package:mqtt_basics_and_client/src/utils/unpack_tool.dart';

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
}
