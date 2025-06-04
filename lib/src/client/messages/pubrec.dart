
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/hex/reason_code.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT PUBREC message – sent by receiver to acknowledge receipt of a QoS 2 PUBLISH.
class PubRec extends AbstractMessage {
  int _messageId = 0;
  int _code = ReasonCode.success;

  /// Gets the message ID this PUBREC relates to
  int get messageId => _messageId;

  /// Sets the message ID for PUBREC
  PubRec setMessageId(int messageId) {
    _messageId = messageId;
    return this;
  }

  /// Gets the reason code
  int get code => _code;

  /// Sets the reason code
  PubRec setCode(int code) {
    _code = code;
    return this;
  }

  /// Constructs the PUBREC packet structure
  /// Returns a structured map or an encoded binary packet depending on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.pubRec,
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
    return Pack.pubRec(getContents());
  }
}
