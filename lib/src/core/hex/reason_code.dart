
/// MQTT v5 Reason Codes used for acknowledgements and errors.
/// Each code maps to specific protocol meanings during client-server communication.
abstract class ReasonCode {
  static const int success = 0x00;

  static const int normalDisconnection = 0x00;
  static const int grantedQos0 = 0x00;
  static const int grantedQos1 = 0x01;
  static const int grantedQos2 = 0x02;

  static const int disconnectWithWillMessage = 0x04;

  static const int noMatchingSubscribers = 0x10;
  static const int noSubscriptionExisted = 0x11;

  static const int continueAuthentication = 0x18;
  static const int reAuthenticate = 0x19;

  static const int unspecifiedError = 0x80;
  static const int malformedPacket = 0x81;
  static const int protocolError = 0x82;
  static const int implementationSpecificError = 0x83;
  static const int unsupportedProtocolVersion = 0x84;
  static const int clientIdentifierNotValid = 0x85;
  static const int badUserNameOrPassword = 0x86;
  static const int notAuthorized = 0x87;
  static const int serverUnavailable = 0x88;
  static const int serverBusy = 0x89;
  static const int banned = 0x8A;

  static const int badAuthMethod = 0x8C;
  static const int topicNameInvalid = 0x90;
  static const int packetTooLarge = 0x95;
  static const int quotaExceeded = 0x97;
  static const int payloadFormatInvalid = 0x99;
  static const int retainNotSupported = 0x9A;
  static const int qosNotSupported = 0x9B;
  static const int useAnotherServer = 0x9C;
  static const int serverMoved = 0x9D;
  static const int connectionRateExceeded = 0x9F;
}