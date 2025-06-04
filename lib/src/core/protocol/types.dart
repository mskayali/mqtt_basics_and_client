
/// MQTT control packet types defined by the protocol spec.
/// These values identify packet intent during communication.
class Types {
  static const int connect = 1; // Client request to connect to Server
  static const int connack = 2; // Connect acknowledgment
  static const int publish = 3; // Publish message
  static const int pubAck = 4; // Publish acknowledgment
  static const int pubRec = 5; // Publish received (QoS 2, step 1)
  static const int pubRel = 6; // Publish release (QoS 2, step 2)
  static const int pubComp = 7; // Publish complete (QoS 2, step 3)
  static const int subscribe = 8; // Client subscribe request
  static const int subAck = 9; // Subscribe acknowledgment
  static const int unsubscribe = 10; // Unsubscribe request
  static const int unsubAck = 11; // Unsubscribe acknowledgment
  static const int pingReq = 12; // PING request
  static const int pingResp = 13; // PING response
  static const int disconnect = 14; // Client is disconnecting
  static const int auth = 15; // Authentication exchange (MQTT 5.0)
}
