
import 'package:mqtt_basics_and_client/src/core/constants.dart';

/// Configuration class for the MQTT client.
/// Holds credentials, protocol, keep-alive, headers, and socket config.
class ClientConfig {
  String clientId = '';
  Map<String, dynamic> swooleConfig = {
    'open_mqtt_protocol': true,
  };

  Map<String, String> headers = {
    'Sec-Websocket-Protocol': 'mqtt',
  };

  String userName = '';
  String password = '';
  int keepAlive = 0;
  String protocolName = mqttProtocolName;
  int protocolLevel = mqttProtocolLevel311;
  int sockType = 1; // Placeholder for TCP or SSL (Dart doesn't need this directly)

  /// Optional constructor to initialize fields from a map
  ClientConfig.fromMap(Map<String, dynamic> data) {
    data.forEach((key, value) {
      switch (key) {
        case 'clientId':
          clientId = value;
          break;
        case 'swooleConfig':
          swooleConfig = Map<String, dynamic>.from(value);
          break;
        case 'headers':
          headers = Map<String, String>.from(value);
          break;
        case 'userName':
          userName = value;
          break;
        case 'password':
          password = value;
          break;
        case 'keepAlive':
          keepAlive = value;
          break;
        case 'protocolName':
          protocolName = value;
          break;
        case 'protocolLevel':
          protocolLevel = value;
          break;
        case 'sockType':
          sockType = value;
          break;
      }
    });
  }

  /// Getters to match PHP style API
  Map<String, dynamic> getSwooleConfig() => swooleConfig;
  String getUserName() => userName;
  String getPassword() => password;
  String getProtocolName() => protocolName;
  int getProtocolLevel() => protocolLevel;
  int getKeepAlive() => keepAlive;
  String getClientId() => clientId;
}
