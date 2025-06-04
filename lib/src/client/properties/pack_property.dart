
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/properties/packet_map.dart';
import 'package:mqtt_basics_and_client/src/core/hex/property.dart';
import 'package:mqtt_basics_and_client/src/utils/pack_tool.dart';

/// Encodes MQTT v5 CONNECT properties into binary format.
class PackProperty {
  /// Encodes CONNECT packet properties into binary format
  static Uint8List encode(Map<String, dynamic> data) {
    final buffer = BytesBuilder();
    final Map<String, int> connectMap = PacketMap.connect.map((k, v) => MapEntry(v, k));

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      final property = connectMap[key];

      if (property == null) continue;

      buffer.addByte(property);
      switch (property) {
        case HexProperty.sessionExpiryInterval:
        case HexProperty.maximumPacketSize:
          buffer.add(PackTool.encodeInt32(value));
          break;

        case HexProperty.authenticationMethod:
        case HexProperty.authenticationData:
        case HexProperty.responseInformation:
        case HexProperty.assignedClientIdentifier:
        case HexProperty.serverReference:
        case HexProperty.reasonString:
        case HexProperty.contentType:
        case HexProperty.responseTopic:
        case HexProperty.correlationData:
          buffer.add(PackTool.encodeString(value));
          break;

        case HexProperty.receiveMaximum:
        case HexProperty.topicAliasMaximum:
        case HexProperty.topicAlias:
        case HexProperty.serverKeepAlive:
          buffer.add(PackTool.encodeInt16(value));
          break;

        case HexProperty.requestProblemInformation:
        case HexProperty.requestResponseInformation:
        case HexProperty.payloadFormatIndicator:
        case HexProperty.retainAvailable:
        case HexProperty.maximumQos:
        case HexProperty.wildcardSubscriptionAvailable:
        case HexProperty.subscriptionIdentifierAvailable:
        case HexProperty.sharedSubscriptionAvailable:
          buffer.addByte(value);
          break;

        case HexProperty.userProperty:
          if (value is Map<String, String>) {
            for (var entry in value.entries) {
              buffer.addByte(HexProperty.userProperty);
              buffer.add(PackTool.encodeString(entry.key));
              buffer.add(PackTool.encodeString(entry.value));
            }
          }
          break;
      }
    }

    final propertyBytes = buffer.toBytes();
    final propertyLength = PackTool.encodeVariableByteInteger(propertyBytes.length);

    return Uint8List.fromList([...propertyLength, ...propertyBytes]);
  }
}
