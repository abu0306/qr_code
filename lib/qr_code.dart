import 'dart:async';

import 'package:flutter/services.dart';

class QrCode {
  static const MethodChannel _channel =
      const MethodChannel('qr_code');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
