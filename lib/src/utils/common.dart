
import 'dart:convert';

/// Utility for printing byte-level debug output in readable format.
class Common {
  /// Prints the byte-level binary structure of a string for inspection.
  static void printf(String data) {
    final bytes = utf8.encode(data);
    final cyan = '\x1B[36m';
    final reset = '\x1B[0m';

    print(cyan);
    for (var i = 0; i < bytes.length; i++) {
      final ascii = bytes[i];
      final chr = ascii > 31 ? String.fromCharCode(ascii) : ' ';
      final binary = ascii.toRadixString(2).padLeft(8, '0');
      final hex = ascii.toRadixString(16).padLeft(2, '0');
      print('${i.toString().padLeft(4)}: $binary : 0x$hex : $ascii : $chr');
    }
    print(reset);
  }
}
