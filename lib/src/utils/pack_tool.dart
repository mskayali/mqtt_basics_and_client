// lib/utils/pack_tool.dart

import 'dart:convert';
import 'dart:typed_data';

/// Utility class for encoding and decoding MQTT-compliant binary formats.
class PackTool {
  /// Encodes a string with a 2-byte length prefix (Big Endian)
  static Uint8List encodeString(String str) {
    final bytes = utf8.encode(str);
    final length = bytes.length;
    final result = BytesBuilder();
    result.addByte((length >> 8) & 0xFF); // high byte
    result.addByte(length & 0xFF); // low byte
    result.add(bytes);
    return result.toBytes();
  }

  /// Encodes a key-value pair as two MQTT strings
  static Uint8List encodeStringPair(String key, String value) {
    final builder = BytesBuilder();
    builder.add(encodeString(key));
    builder.add(encodeString(value));
    return builder.toBytes();
  }

  /// Encodes a 32-bit integer (Big Endian)
  static Uint8List encodeInt32(int value) {
    final buffer = ByteData(4);
    buffer.setUint32(0, value);
    return buffer.buffer.asUint8List();
  }

  /// Encodes a 16-bit integer (Big Endian)
  static Uint8List encodeInt16(int value) {
    final buffer = ByteData(2);
    buffer.setUint16(0, value);
    return buffer.buffer.asUint8List();
  }

  /// Encodes an integer as a Variable Byte Integer (MQTT format)
  static Uint8List encodeVariableByteInteger(int value) {
    final result = <int>[];
    do {
      int digit = value % 128;
      value = value ~/ 128;
      if (value > 0) {
        digit |= 0x80;
      }
      result.add(digit);
    } while (value > 0);
    return Uint8List.fromList(result);
  }

  /// Decodes a Variable Byte Integer from [data] starting at [offset].
  /// Returns a map with 'value' and updated 'offset'.
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
        throw FormatException('Malformed Variable Byte Integer');
      }
    } while ((digit & 0x80) != 0);

    return {'value': value, 'offset': offset};
  }

  /// Encodes MQTT 5.0 properties as key-value pairs with variable byte length prefix
  static Uint8List encodeProperties(Map<String, dynamic> props) {
    final builder = BytesBuilder();
    props.forEach((key, value) {
      builder.add(encodeString(key));
      builder.add(encodeString(value.toString()));
    });

    final propsBytes = builder.toBytes();
    final lengthBytes = encodeVariableByteInteger(propsBytes.length);

    return Uint8List.fromList([...lengthBytes, ...propsBytes]);
  }
}
