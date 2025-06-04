// example/mqtt_client_example.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/mqtt_message_pack.dart';
import 'package:mqtt_basics_and_client/src/utils/pack_tool.dart';

void main() async {
  const brokerHost = 'broker.hivemq.com';
  const brokerPort = 1883;

  //
  // 1. Build a CONNECT packet (MQTT 3.1.1)
  //
  // Instead of a Connect class, we assemble a Map with the required fields.
  final connectMap = <String, dynamic>{
    // Protocol name and level for MQTT 3.1.1:
    'protocol_name': 'MQTT',
    'protocol_level': 4, // mqttProtocolLevel311 = 4
    'clean_session': true, // clean session flag
    'client_id': 'dart_client', // client identifier
    'keep_alive': 60, // keep‐alive in seconds
    // (If you wanted MQTT 5.0, you could add 'properties', 'will', 'user_name', 'password', etc.)
  };

  // Build the variable header + payload:
  final connectVariableHeader = Pack.connect(connectMap);

  // Build the fixed header:
  final connectFixedHeader = _buildFixedHeader(
    packetType: 1, // CONNECT control packet type = 1
    flags: 0, // CONNECT flags are always 0
    bodyLength: connectVariableHeader.length,
  );

  // Combine both:
  final connectPacket = Uint8List.fromList([
    ...connectFixedHeader,
    ...connectVariableHeader,
  ]);

  //
  // 2. Open a TCP socket and send CONNECT
  //
  final socket = await Socket.connect(brokerHost, brokerPort);
  print('Connected to MQTT broker at $brokerHost:$brokerPort');
  socket.add(connectPacket);
  await socket.flush();

  //
  // 3. Read CONNACK (simple read; real code should parse the variable‐length field)
  //
  final connAckBytes = await socket.first;
  print('Received CONNACK raw bytes: $connAckBytes');

  //
  // 4. Build a PUBLISH packet (QoS 1 example)
  //
  final publishMap = <String, dynamic>{
    'topic': 'example/dart',
    'message': 'Hello from Dart!',
    'qos': 1,
    'message_id': 10,
    // (For MQTT 5.0 you could add 'properties': {...})
  };
  final publishVariableHeader = Pack.publish(publishMap);

  // For QoS 1, PUBLISH flags = 0b0010 (DUP=0, QoS=1, RETAIN=0):
  final publishFixedHeader = _buildFixedHeader(
    packetType: 3, // PUBLISH = 3
    flags: 0x02, // (1 << 1)
    bodyLength: publishVariableHeader.length,
  );
  final publishPacket = Uint8List.fromList([
    ...publishFixedHeader,
    ...publishVariableHeader,
  ]);

  // Send PUBLISH
  socket.add(publishPacket);
  await socket.flush();
  print('PUBLISH sent to topic "example/dart"');

  //
  // 5. Send PINGREQ (fixed header only)
  //
  // PINGREQ control packet type = 12 (0xC0), remaining length = 0:
  final pingReqPacket = Uint8List.fromList([0xC0, 0x00]);
  socket.add(pingReqPacket);
  await socket.flush();
  print('PINGREQ sent');

  //
  // 6. Read PINGRESP
  //
  final pingRespBytes = await socket.first;
  print('Received PINGRESP raw bytes: $pingRespBytes');

  //
  // 7. Build and send DISCONNECT (MQTT 3.1.1)
  //
  // For MQTT 3.1.1, DISCONNECT has no variable header/payload → fixed header only.
  // We’ll send fixed header [0xE0, 0x00]:
  final disconnectPacket = Uint8List.fromList([0xE0, 0x00]);
  socket.add(disconnectPacket);
  await socket.flush();
  socket.destroy();
  print('Disconnected from broker');
}

/// Helper to build the MQTT fixed header (first byte + Remaining Length)
Uint8List _buildFixedHeader({
  required int packetType,
  required int flags,
  required int bodyLength,
}) {
  // First byte = (packetType << 4) | (flags & 0x0F)
  final firstByte = ((packetType & 0x0F) << 4) | (flags & 0x0F);
  // Remaining Length encoded as Variable Byte Integer
  final remainingBytes = PackTool.encodeVariableByteInteger(bodyLength);
  return Uint8List.fromList([firstByte, ...remainingBytes]);
}
