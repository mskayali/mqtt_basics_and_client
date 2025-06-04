
/// MQTT v5 property identifiers as hexadecimal byte values.
/// Used during encoding/decoding of MQTT control packets.
class HexProperty {
  static const int payloadFormatIndicator = 0x01;
  static const int messageExpiryInterval = 0x02;
  static const int contentType = 0x03;
  static const int responseTopic = 0x08;
  static const int correlationData = 0x09;
  static const int subscriptionIdentifier = 0x0B;
  static const int sessionExpiryInterval = 0x11;
  static const int assignedClientIdentifier = 0x12;
  static const int serverKeepAlive = 0x13;
  static const int authenticationMethod = 0x15;
  static const int authenticationData = 0x16;
  static const int requestProblemInformation = 0x17;
  static const int willDelayInterval = 0x18;
  static const int requestResponseInformation = 0x19;
  static const int responseInformation = 0x1A;
  static const int serverReference = 0x1C;
  static const int reasonString = 0x1F;
  static const int receiveMaximum = 0x21;
  static const int topicAliasMaximum = 0x22;
  static const int topicAlias = 0x23;
  static const int maximumQos = 0x24;
  static const int retainAvailable = 0x25;
  static const int userProperty = 0x26;
  static const int maximumPacketSize = 0x27;
  static const int wildcardSubscriptionAvailable = 0x28;
  static const int subscriptionIdentifierAvailable = 0x29;
  static const int sharedSubscriptionAvailable = 0x2A;
}
