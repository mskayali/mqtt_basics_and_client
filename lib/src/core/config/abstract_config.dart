
/// Abstract base class for configuration classes.
/// Allows initializing configuration fields from a Map.
abstract class AbstractConfig {
  AbstractConfig([Map<String, dynamic>? data]) {
    data?.forEach((key, value) {
      final methodName = 'set${_capitalize(key)}';
      final symbol = Symbol(methodName);

      // If a setter exists, invoke it
      if (_hasSetter(this, symbol)) {
        Function.apply(this as dynamic, [value], {symbol: value});
      } else {
        // Fallback: assign as property if needed (no-op in base)
      }
    });
  }

  /// Helper to check if an instance has a method (dynamic check)
  bool _hasSetter(Object obj, Symbol symbol) {
    return obj.runtimeType.toString().contains(symbol.toString().replaceAll('Symbol("', '').replaceAll('")', ''));
  }

  /// Capitalizes the first letter of a string
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
