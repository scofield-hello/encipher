import 'dart:async';

import 'package:flutter/services.dart';

enum EncryptType { STANDARD, CHUANGDUN }

class Encipher {
  static const MethodChannel _channel = const MethodChannel('encipher');

  static Future<String> encrypt(String raw,
      {EncryptType type = EncryptType.STANDARD, int repeat = 1, String salt = ""}) async {
    assert(type != null && raw != null && repeat > 0);
    if (type == EncryptType.STANDARD) {
      assert(salt != null);
    }
    final String encrypted = await _channel
        .invokeMethod('encrypt', {'type': type.index, 'raw': raw, 'repeat': repeat, 'salt': salt});
    return encrypted;
  }
}
