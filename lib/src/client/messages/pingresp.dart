
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT PINGRESP message – sent by the broker in response to a client's PINGREQ.
class PingResp extends AbstractMessage {
  /// Constructs the PINGRESP packet structure
  /// Returns either a structure map or the encoded packet based on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.pingResp,
    };

    return buffer;
  }

  @override
  Uint8List getBuffer() {
    return Pack.pingResp(getContents());
  }
}
