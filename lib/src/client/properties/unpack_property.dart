
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/properties/packet_map.dart';
import 'package:mqtt_basics_and_client/src/core/exceptions/invalid_argument_exception.dart';
import 'package:mqtt_basics_and_client/src/core/hex/property.dart';
import 'package:mqtt_basics_and_client/src/utils/unpack_tool.dart';

/// Decodes MQTT v5 property bytes from CONNECT packets into usable maps.
class UnPackProperty {
  /// Decodes MQTT properties and returns a map and the updated offset
  static Map<String, dynamic> decode(Uint8List data, int offset) {
    final buffer = data.buffer.asByteData();
    final properties = <String, dynamic>{};

    // First, decode the variable byte length prefix
    final decodedLength = UnPackTool.decodeVariableByteInteger(data, offset);
    final length = decodedLength['value'] as int;
    offset = decodedLength['offset'] as int;

    final end = offset + length;

    while (offset < end) {
      final property = buffer.getUint8(offset++);
      final key = PacketMap.connect[property];
      if (key == null) {
        throw InvalidArgumentException('Unknown property identifier: $property');
      }

      switch (property) {
        case HexProperty.sessionExpiryInterval:
        case HexProperty.maximumPacketSize:
          properties[key] = buffer.getUint32(offset);
          offset += 4;
          break;

        case HexProperty.receiveMaximum:
        case HexProperty.topicAliasMaximum:
        case HexProperty.topicAlias:
        case HexProperty.serverKeepAlive:
          properties[key] = buffer.getUint16(offset);
          offset += 2;
          break;

        case HexProperty.payloadFormatIndicator:
        case HexProperty.requestProblemInformation:
        case HexProperty.requestResponseInformation:
        case HexProperty.retainAvailable:
        case HexProperty.maximumQos:
        case HexProperty.wildcardSubscriptionAvailable:
        case HexProperty.subscriptionIdentifierAvailable:
        case HexProperty.sharedSubscriptionAvailable:
          properties[key] = buffer.getUint8(offset);
          offset += 1;
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
          final strResult = UnPackTool.decodeString(data, offset);
          properties[key] = strResult['value'];
          offset = strResult['offset'];
          break;

        case HexProperty.userProperty:
          final kResult = UnPackTool.decodeString(data, offset);
          offset = kResult['offset'];
          final vResult = UnPackTool.decodeString(data, offset);
          offset = vResult['offset'];
          final userKey = kResult['value'];
          final userVal = vResult['value'];
          properties.putIfAbsent(key, () => <String, String>{});
          (properties[key] as Map<String, String>)[userKey] = userVal;
          break;

        default:
          throw InvalidArgumentException('Unhandled property type: $property');
      }
    }

    return {
      'properties': properties,
      'offset': offset,
    };
  }
}
