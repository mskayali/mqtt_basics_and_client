// test/mqtt_basics_and_client_test.dart

import 'dart:typed_data';

import 'package:mqtt_basics_and_client/mqtt_basics_and_client.dart';
import 'package:mqtt_basics_and_client/src/utils/pack_tool.dart';
import 'package:test/test.dart';

void main() {
  group('PackTool Utility Tests', () {
    test('encodeString encodes "MQTT" correctly', () {
      final encoded = PackTool.encodeString('MQTT');
      // "MQTT" length = 4 -> 0x00 0x04, followed by ASCII codes
      expect(encoded, equals(Uint8List.fromList([0x00, 0x04, 0x4D, 0x51, 0x54, 0x54])));
    });

    test('encodeVariableByteInteger encodes 128 correctly', () {
      final encoded = PackTool.encodeVariableByteInteger(128);
      // 128 should be encoded as [0x80, 0x01]
      expect(encoded, equals(Uint8List.fromList([0x80, 0x01])));
    });

    test('encodeProperties encodes simple map correctly', () {
      final props = {'key': 'value'};
      final encoded = PackTool.encodeProperties(props);
      // First byte(s) represent length; ensure the length matches payload
      final length = PackTool.decodeVariableByteInteger(encoded, 0)['value'] as int;
      expect(encoded.length - (encoded.indexOf(0x6B) - 1), equals(length));
    });
  });

  group('Message Classes Map Content Tests', () {
    test('PubAck getContents as map', () {
      final pubAck = PubAck()
        ..setMessageId(42)
        ..setCode(0x01)
        ..setProperty('reasonString', 'Test');
      final contents = pubAck.getContents();
      expect(contents['type'], equals(4)); // Types.pubAck = 4
      expect(contents['message_id'], equals(42));
      expect(contents['code'], equals(0x01));
      expect(contents['properties']['reasonString'], equals('Test'));
    });

    test('Publish getContents as map', () {
      final publish = Publish()
        ..setTopic('test/topic')
        ..setMessage('hello')
        ..setQos(1)
        ..setMessageId(99)
        ..setProperty('payloadFormatIndicator', 1);
      final contents = publish.getContents();
      expect(contents['type'], equals(3)); // Types.publish = 3
      expect(contents['topic'], equals('test/topic'));
      expect(contents['message'], equals('hello'));
      expect(contents['qos'], equals(1));
      expect(contents['message_id'], equals(99));
      expect(contents['properties']['payloadFormatIndicator'], equals(1));
    });

    test('Will getContents as map', () {
      final will = Will()
        ..setTopic('last/will')
        ..setMessage('bye')
        ..setQos(2)
        ..setRetain(1)
        ..setProperty('contentType', 'text/plain');
      final contents = will.getContents();
      expect(contents['topic'], equals('last/will'));
      expect(contents['message'], equals('bye'));
      expect(contents['qos'], equals(2));
      expect(contents['retain'], equals(1));
      expect(contents['properties']['contentType'], equals('text/plain'));
    });

    test('ConnAck getContents as map', () {
      final connAck = ConnAck()
        ..setSessionPresent(1)
        ..setCode(0x00)
        ..setProperty('sessionExpiryInterval', 30);
      final contents = connAck.getContents();
      expect(contents['type'], equals(2)); // Types.connack = 2
      expect(contents['session_present'], equals(1));
      expect(contents['code'], equals(0x00));
      expect(contents['properties']['sessionExpiryInterval'], equals(30));
    });

    test('Disconnect getContents as map', () {
      final disconnect = DisConnect()
        ..setCode(0x00)
        ..setProperty('reasonString', 'Goodbye');
      final contents = disconnect.getContents();
      expect(contents['type'], equals(14)); // Types.disconnect = 14
      expect(contents['code'], equals(0x00));
      expect(contents['properties']['reasonString'], equals('Goodbye'));
    });

    test('PingResp getContents as map', () {
      final pingResp = PingResp();
      final contents = pingResp.getContents();
      expect(contents['type'], equals(13)); // Types.pingResp = 13
    });

    test('SubAck getContents as map', () {
      final subAck = SubAck()
        ..setMessageId(123)
        ..setCodes([0, 1, 2])
        ..setProperty('subscriptionIdentifier', 7);
      final contents = subAck.getContents();
      expect(contents['type'], equals(9)); // Types.subAck = 9
      expect(contents['message_id'], equals(123));
      expect(contents['codes'], equals([0, 1, 2]));
      expect(contents['properties']['subscriptionIdentifier'], equals(7));
    });

    test('UnSubAck getContents as map', () {
      final unsubAck = UnSubAck()
        ..setMessageId(456)
        ..setCodes([0, 128])
        ..setProperty('reasonString', 'Done');
      final contents = unsubAck.getContents();
      expect(contents['type'], equals(11)); // Types.unsubAck = 11
      expect(contents['message_id'], equals(456));
      expect(contents['codes'], equals([0, 128]));
      expect(contents['properties']['reasonString'], equals('Done'));
    });

    test('Auth getContents as map', () {
      final authMsg = Auth()
        ..setCode(0x18)
        ..setProperty('authenticationMethod', 'token');
      final contents = authMsg.getContents();
      expect(contents['type'], equals(15)); // Types.auth = 15
      expect(contents['code'], equals(0x18));
      expect(contents['properties']['authenticationMethod'], equals('token'));
    });
  });

  group('Pack Encoding Tests', () {
    test('PubAck encoding returns non-empty bytes', () {
      final pubAck = PubAck()
        ..setMessageId(10)
        ..setCode(0x00);
      final encoded = Pack.pubAck(pubAck.getContents());
      expect(encoded, isNotEmpty);
      expect(encoded.length, greaterThanOrEqualTo(2));
    });

    test('Disconnect encoding returns at least byte for reason code', () {
      final disconnect = DisConnect()..setCode(0x00);
      final encoded = Pack.disconnect(disconnect.getContents());
      expect(encoded.length, greaterThanOrEqualTo(1));
      // First byte should match reason code
      expect(encoded[0], equals(0x00));
    });

    test('Publish encoding returns non-empty payload', () {
      final publish = Publish()
        ..setTopic('test')
        ..setMessage('msg')
        ..setQos(0);
      final encoded = Pack.publish(publish.getContents());
      expect(encoded, isNotEmpty);
    });

    test('ConnAck encoding returns correct header for sessionPresent and code', () {
      final connAck = ConnAck()
        ..setSessionPresent(1)
        ..setCode(0x00);
      final encoded = Pack.connAck(connAck.getContents());
      expect(encoded.length, greaterThanOrEqualTo(2));
      // First byte = sessionPresent flag
      expect(encoded[0], equals(1));
      // Second byte = reason code
      expect(encoded[1], equals(0x00));
    });

    test('PingResp binary fixed header is correct', () {
      final encoded = Pack.pingResp({});
      expect(encoded, equals(Uint8List.fromList([0xD0, 0x00])));
    });
  });
}
