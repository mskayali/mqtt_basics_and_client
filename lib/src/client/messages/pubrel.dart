
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/hex/reason_code.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT PUBREL message – second stage of QoS 2 publish flow, confirming message handling.
class PubRel extends AbstractMessage {
  int _messageId = 0;
  int _code = ReasonCode.success;

  /// Gets the message ID this PUBREL is responding to
  int get messageId => _messageId;

  /// Sets the message ID for this PUBREL
  PubRel setMessageId(int messageId) {
    _messageId = messageId;
    return this;
  }

  /// Gets the reason code
  int get code => _code;

  /// Sets the reason code
  PubRel setCode(int code) {
    _code = code;
    return this;
  }

  /// Constructs the PUBREL packet structure
  /// Returns a structure map or an encoded binary buffer depending on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.pubRel,
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
    return Pack.pubRel(getContents());
  }
}
