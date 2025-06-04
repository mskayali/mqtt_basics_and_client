
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/constants.dart';
import 'package:mqtt_basics_and_client/src/core/protocol/types.dart';

/// MQTT PUBLISH message – used to send a message to a topic.
/// Supports QoS, retain, and duplicate flags.
class Publish extends AbstractMessage {
  String _topic = '';
  String _message = '';
  int _qos = mqttQos0;
  int _dup = mqttDup0;
  int _retain = mqttRetain0;
  int _messageId = 0;

  /// Gets the topic the message is published to
  String get topic => _topic;

  /// Sets the topic
  Publish setTopic(String topic) {
    _topic = topic;
    return this;
  }

  /// Gets the message payload
  String get message => _message;

  /// Sets the message payload
  Publish setMessage(String message) {
    _message = message;
    return this;
  }

  /// Gets the QoS level
  int get qos => _qos;

  /// Sets the QoS level
  Publish setQos(int qos) {
    _qos = qos;
    return this;
  }

  /// Gets the DUP flag
  int get dup => _dup;

  /// Sets the DUP flag
  Publish setDup(int dup) {
    _dup = dup;
    return this;
  }

  /// Gets the RETAIN flag
  int get retain => _retain;

  /// Sets the RETAIN flag
  Publish setRetain(int retain) {
    _retain = retain;
    return this;
  }

  /// Gets the message ID (only for QoS 1 or 2)
  int get messageId => _messageId;

  /// Sets the message ID
  Publish setMessageId(int messageId) {
    _messageId = messageId;
    return this;
  }

  /// Constructs the PUBLISH packet structure
  /// Returns either a structured map or an encoded binary payload.
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'type': Types.publish,
      'topic': topic,
      'message': message,
      'qos': qos,
      'dup': dup,
      'retain': retain,
    };

    if (qos > 0) {
      buffer['message_id'] = messageId;
    }

    if (getProtocolLevel() == 5) {
      final props = super.getProperties();
      if (props.isNotEmpty) {
        buffer['properties'] = props;
      }
    }

    return buffer;
  }

  @override
  Uint8List getBuffer() {
    return Pack.publish(getContents());
  }
}
