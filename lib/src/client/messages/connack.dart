
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/constants.dart';
import 'package:mqtt_basics_and_client/src/core/hex/reason_code.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT CONNACK message – sent by broker in response to CONNECT.
/// Indicates connection success or failure with a reason code.
class ConnAck extends AbstractMessage {
  int _code = ReasonCode.success;
  int _sessionPresent = mqttSessionPresent0;

  /// Gets the CONNACK return code
  int get code => _code;

  /// Sets the CONNACK return code
  ConnAck setCode(int code) {
    _code = code;
    return this;
  }

  /// Gets the session present flag (1 or 0)
  int get sessionPresent => _sessionPresent;

  /// Sets the session present flag (1 or 0)
  ConnAck setSessionPresent(int sessionPresent) {
    _sessionPresent = sessionPresent;
    return this;
  }

  /// Encodes the CONNACK message structure.
  /// Returns structured map or encoded binary based on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.connack,
      'code': code,
      'session_present': sessionPresent,
    };

    final props = getProperties();
    if (props.isNotEmpty) {
      buffer['properties'] = props;
    }

    return buffer;
  }

  @override
  Uint8List getBuffer() {
    return Pack.connAck(getContents());
  }
}
