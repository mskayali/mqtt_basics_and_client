
/// Constants and interface declarations for MQTT protocol compliance.
abstract class ProtocolInterface {
  static const int mqttProtocolLevel31 = 3;
  static const int mqttProtocolLevel311 = 4;
  static const int mqttProtocolLevel50 = 5;

  static const String mqisdpProtocolName = 'MQIsdp';
  static const String mqttProtocolName = 'MQTT';

  static const int mqttQos0 = 0;
  static const int mqttQos1 = 1;
  static const int mqttQos2 = 2;

  static const int mqttRetain0 = 0;
  static const int mqttRetain1 = 1;
  static const int mqttRetain2 = 2;

  static const int mqttDup0 = 0;
  static const int mqttDup1 = 1;

  static const int mqttSessionPresent0 = 0;
  static const int mqttSessionPresent1 = 1;

  // Abstract methods for packing/unpacking messages should be declared in Dart interfaces if needed
}
