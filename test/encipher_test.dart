import 'package:encipher/encipher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('encipher');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'encipher';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('encrypt', () async {
    expect(await Encipher.encrypt("123456", type: EncryptType.STANDARD, salt: "ABC", repeat: 14),
        '98d9081acb339c13c750dd4079642365');
    expect(await Encipher.encrypt("123456", type: EncryptType.CHUANGDUN, repeat: 14),
        '1ACBAB941C41FC3618805F702C2F36B2');
  });
}
