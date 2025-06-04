
import 'package:mqtt_basics_and_client/src/core/hex/property.dart';

/// Maps MQTT v5 property identifiers to their corresponding field names.
class PacketMap {
  /// Properties allowed in the CONNECT packet and their mapping
  static const Map<int, String> connect = {
    HexProperty.sessionExpiryInterval: 'session_expiry_interval',
    HexProperty.authenticationMethod: 'authentication_method',
    HexProperty.authenticationData: 'authentication_data',
    HexProperty.requestProblemInformation: 'request_problem_information',
    HexProperty.requestResponseInformation: 'request_response_information',
    HexProperty.receiveMaximum: 'receive_maximum',
    HexProperty.topicAliasMaximum: 'topic_alias_maximum',
    HexProperty.userProperty: 'user_property',
    HexProperty.maximumPacketSize: 'maximum_packet_size',
  };
}
