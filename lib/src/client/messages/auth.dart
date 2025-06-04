
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart';
import 'package:mqtt_basics_and_client/src/core/hex/reason_code.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT AUTH message for MQTT 5.0 authentication negotiation.
class Auth extends AbstractMessage {
  int _code = ReasonCode.success;

  /// Gets the reason code for this AUTH message
  int get code => _code;

  /// Sets the reason code for this AUTH message
  Auth setCode(int code) {
    _code = code;
    return this;
  }

  /// Constructs the AUTH packet structure
  /// Returns either a structured map or an encoded packet depending on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.auth,
      'code': code,
    };

    final props = super.getProperties();
    if (props.isNotEmpty) {
      buffer['properties'] = props;
    }

    return buffer;
  }

  @override
  Uint8List getBuffer() {
    return Pack.auth(getContents());
  }

}
