
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart';
import 'package:mqtt_basics_and_client/src/core/hex/reason_code.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT DISCONNECT message – used by the client to gracefully terminate a session.
class DisConnect extends AbstractMessage {
  int _code = ReasonCode.normalDisconnection;

  /// Gets the disconnect reason code (only used in MQTT 5.0)
  int get code => _code;

  /// Sets the disconnect reason code
  DisConnect setCode(int code) {
    _code = code;
    return this;
  }

  /// Constructs the DISCONNECT packet as a map
  /// This is an internal representation before being serialized to bytes.
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.disconnect,
    };

    if (getProtocolLevel() == 5) {
      buffer['code'] = code;
      final props = super.getProperties();
      if (props.isNotEmpty) {
        buffer['properties'] = props;
      }
    }

    return buffer;
  }

  @override
  Uint8List getBuffer() {
    return Pack.disconnect(getContents());
  }
}
