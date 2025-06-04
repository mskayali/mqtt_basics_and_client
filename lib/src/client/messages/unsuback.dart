
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT UNSUBACK message – sent by broker to acknowledge an unsubscribe request.
class UnSubAck extends AbstractMessage {
  int _messageId = 0;
  List<int> _codes = [];

  /// Gets the message ID for the unsubscribe request
  int get messageId => _messageId;

  /// Sets the message ID
  UnSubAck setMessageId(int messageId) {
    _messageId = messageId;
    return this;
  }

  /// Gets the result codes
  List<int> get codes => _codes;

  /// Sets the result codes
  UnSubAck setCodes(List<int> codes) {
    _codes = codes;
    return this;
  }

  /// Constructs the UNSUBACK packet structure
  /// Returns a structured map or an encoded binary packet depending on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.unsubAck,
      'message_id': messageId,
      'codes': codes,
    };

    final props = getProperties();
    if (getProtocolLevel() == 5 && props.isNotEmpty) {
      buffer['properties'] = props;
    }

    return buffer;
  }

  @override
  Uint8List getBuffer() {
    return Pack.unsubAck(getContents());
  }
}
