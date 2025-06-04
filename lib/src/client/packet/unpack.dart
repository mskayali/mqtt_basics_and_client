
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/utils/unpack_tool.dart';

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
}
