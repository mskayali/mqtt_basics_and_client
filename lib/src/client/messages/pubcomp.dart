
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed pack method
import 'package:mqtt_basics_and_client/src/core/hex/reason_code.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT PUBCOMP message – final stage of QoS 2 message delivery, acknowledging PUBREL.
class PubComp extends AbstractMessage {
  int _messageId = 0;
  int _code = ReasonCode.success;

  /// Gets the ID of the message being finalized
  int get messageId => _messageId;

  /// Sets the message ID being finalized
  PubComp setMessageId(int messageId) {
    _messageId = messageId;
    return this;
  }

  /// Gets the reason code for the PUBCOMP
  int get code => _code;

  /// Sets the reason code
  PubComp setCode(int code) {
    _code = code;
    return this;
  }

  /// Constructs the PUBCOMP packet structure
  /// Returns either the structure map or the encoded binary.
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.pubComp,
      'message_id': messageId,
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
    return Pack.pubComp(getContents());
  }
}
