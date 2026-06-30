import 'package:flutter/services.dart';

class Ada {
  static const _channel = MethodChannel("com.adservrs.ada/Ada");
  static var _initialized = false;

  const Ada._();

  ///
  /// Initialize instance of the AdaSDK.
  ///
  static Ada initialize({String? iosStoreUrl}) {
    if (!_initialized) {
      _channel.invokeMethod("initialize", {"iosStoreUrl": iosStoreUrl});
      _initialized = true;
    }
    return const Ada._();
  }
}