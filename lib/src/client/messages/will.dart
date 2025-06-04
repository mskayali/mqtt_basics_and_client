
import 'dart:typed_data';

import 'package:mqtt_basics_and_client/src/client/messages/abstract_message.dart';
import 'package:mqtt_basics_and_client/src/client/packet/pack.dart'; // assumed encoder
import 'package:mqtt_basics_and_client/src/core/constants.dart';

/// MQTT Will message – optional message sent by the broker on unexpected client disconnect.
class Will extends AbstractMessage {
  String _topic = '';
  int _qos = mqttQos0;
  int _retain = mqttRetain0;
  String _message = '';

  /// Gets the topic for the will message
  String get topic => _topic;

  /// Sets the topic for the will message
  Will setTopic(String topic) {
    _topic = topic;
    return this;
  }

  /// Gets the will message payload
  String get message => _message;

  /// Sets the will message payload
  Will setMessage(String message) {
    _message = message;
    return this;
  }

  /// Gets the QoS level for the will message
  int get qos => _qos;

  /// Sets the QoS level
  Will setQos(int qos) {
    _qos = qos;
    return this;
  }

  /// Gets the retain flag for the will message
  int get retain => _retain;

  /// Sets the retain flag
  Will setRetain(int retain) {
    _retain = retain;
    return this;
  }

  /// Constructs the will message
  /// Returns a map for CONNECT usage or encoded binary using [Pack.will].
  @override
  Map<String, dynamic> getContents() {
    final buffer = <String, dynamic>{
      'topic': topic,
      'message': message,
      'qos': qos,
      'retain': retain,
    };

    final props = getProperties();
    if (props.isNotEmpty) {
      buffer['properties'] = props;
    }

    return buffer;
  }

  @override
  Uint8List getBuffer() {
    return Pack.will(getContents());
  }
}
