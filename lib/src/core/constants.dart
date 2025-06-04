
/// MQTT protocol level definitions
const int mqttProtocolLevel31 = 3;
const int mqttProtocolLevel311 = 4;
const int mqttProtocolLevel50 = 5;

/// MQTT protocol names
const String mqisdpProtocolName = 'MQIsdp';
const String mqttProtocolName = 'MQTT';

/// QoS levels
const int mqttQos0 = 0;
const int mqttQos1 = 1;
const int mqttQos2 = 2;

/// Retain flags
const int mqttRetain0 = 0;
const int mqttRetain1 = 1;
const int mqttRetain2 = 2;

/// Duplicate message flags
const int mqttDup0 = 0;
const int mqttDup1 = 1;

/// Session present flags
const int mqttSessionPresent0 = 0;
const int mqttSessionPresent1 = 1;

/// MQTT Control Packet types
const int mqttTypeConnect = 1;
const int mqttTypeConnAck = 2;
const int mqttTypePublish = 3;
const int mqttTypePubAck = 4;
const int mqttTypePubRec = 5;
const int mqttTypePubRel = 6;
const int mqttTypePubComp = 7;
const int mqttTypeSubscribe = 8;
const int mqttTypeSubAck = 9;
const int mqttTypeUnsubscribe = 10;
const int mqttTypeUnSubAck = 11;
const int mqttTypePingReq = 12;
const int mqttTypePingResp = 13;
const int mqttTypeDisconnect = 14;
const int mqttTypeAuth = 15;
