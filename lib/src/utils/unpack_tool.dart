
import 'dart:convert';
import 'dart:typed_data';

/// Utility for decoding MQTT-compliant binary structures into usable Dart data.
class UnPackTool {
  /// Decodes the MQTT control packet type from the first byte
  static int getType(Uint8List data) {
    return data[0] >> 4;
  }

  /// Decodes an MQTT string (2-byte length prefix + UTF-8 string)
  static Map<String, dynamic> decodeString(Uint8List data, int offset) {
    final buffer = data.buffer.asByteData();
    final length = buffer.getUint16(offset);
    offset += 2;
    final bytes = data.sublist(offset, offset + length);
    final value = utf8.decode(bytes);
    offset += length;

    return {'value': value, 'offset': offset};
  }

  /// Decodes a Variable Byte Integer and returns the value and offset
  static Map<String, dynamic> decodeVariableByteInteger(Uint8List data, int offset) {
    int multiplier = 1;
    int value = 0;
    int digit;
    int bytesRead = 0;

    do {
      digit = data[offset++];
      value += (digit & 0x7F) * multiplier;
      multiplier *= 128;
      bytesRead++;

      if (bytesRead > 4) {
        throw Exception('Malformed Variable Byte Integer');
      }
    } while ((digit & 0x80) != 0);

    return {'value': value, 'offset': offset};
  }
}
