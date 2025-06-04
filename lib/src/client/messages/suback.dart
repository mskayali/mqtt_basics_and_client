
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT SUBACK message – sent by broker to acknowledge a SUBSCRIBE request.
class SubAck extends AbstractMessage {
  int _messageId = 0;
  List<int> _codes = [];

  /// Gets the message ID associated with the subscription
  int get messageId => _messageId;

  /// Sets the message ID
  SubAck setMessageId(int messageId) {
    _messageId = messageId;
    return this;
  }

  /// Gets the granted QoS levels or reason codes
  List<int> get codes => _codes;

  /// Sets the granted QoS levels or reason codes
  SubAck setCodes(List<int> codes) {
    _codes = codes;
    return this;
  }

  /// Constructs the SUBACK packet structure
  /// Returns a map or encoded packet depending on [getAsMap].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.subAck,
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
    return Pack.subAck(getContents());
  }
}
