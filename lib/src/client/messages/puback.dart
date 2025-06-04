
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed pack method
import 'package:mqtt_basics_and_client/src/core/hex/reason_code.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT PUBACK message – sent in response to QoS 1 PUBLISH to acknowledge receipt.
class PubAck extends AbstractMessage {
  int _messageId = 0;
  int _code = ReasonCode.success;

  /// Gets the ID of the acknowledged message
  int get messageId => _messageId;

  /// Sets the message ID being acknowledged
  PubAck setMessageId(int messageId) {
    _messageId = messageId;
    return this;
  }

  /// Gets the reason code for the acknowledgment
  int get code => _code;

  /// Sets the reason code
  PubAck setCode(int code) {
    _code = code;
    return this;
  }

  /// Constructs the PUBACK packet structure
  /// Returns either a structured map or an encoded byte buffer depending on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.pubAck,
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
    return Pack.pubAck(getContents());
  }
}
