# Changelog

All notable changes to this project will be documented in this file.

## \[0.1.0] - 2025-06-04

### Added

* **Core utilities**

  * `PackTool`:

    * `encodeString`, `encodeStringPair`, `encodeInt16`, `encodeInt32`
    * `encodeVariableByteInteger`, `decodeVariableByteInteger`
    * `encodeProperties` for MQTT 5.0 property serialization
  * `Common` (debugging utility to print byte‐level content)
* **Packet builders** (`Pack`):

  * `connect`, `will`, `publish`, `pubAck`, `pubRec`, `pubRel`, `pubComp`, `subAck`, `unsubAck`, `pingResp`, `connAck`, `disconnect`, `auth` methods that delegate to `PackTool.encode*`.
* **Message classes** (all extend `AbstractMessage`, each with `getContents({bool getAsMap = false})`):

  * `AbstractMessage` (base class with `protocolLevel`, `properties`, and abstract `getContents`)
  * `Auth`, `ConnAck`, `DisConnect`, `PingResp`
  * `PubAck`, `PubRec`, `PubRel`, `PubComp` (QoS flows)
  * `Publish`, `SubAck`, `UnSubAck`, `Will`
* **Protocol constants and types**:

  * `constants.dart` (MQTT 3.1.1 & 5.0 flags, QoS values, packet‐type integers)
  * `hex/property.dart`, `hex/reason_code.dart` (MQTT 5.0 property identifiers and reason codes)
  * `protocol/types.dart`, `protocol/protocol_interface.dart`
* **Custom exceptions** (`core/exceptions`) for protocol validation:

  * `ConnectException`, `InvalidArgumentException`, `LengthException`, `ProtocolException`, `RuntimeException`

### Changed

* Initial PHP implementation fully ported to Dart, preserving directory structure logic:

  * `src/` → `lib/` with `client/`, `core/`, and `utils/` subfolders
  * All PHP classes and methods converted to idiomatic Dart equivalents with `Uint8List` for binary payloads

### Fixed

* Ensured every `getContents({bool getAsMap = false})` honors the `getAsMap` flag (returns a `Map<String, dynamic>` when `true`, otherwise a `Uint8List`)
* Added missing `decodeVariableByteInteger` to `PackTool` for MQTT 5.0 property decoding

---

### Notes

* This is the inaugural release (v0.1.0). Future versions will document any API enhancements, bug fixes, or protocol‐level improvements.
