import 'dart:async';

import 'package:encipher/encipher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _encrypted = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String encrypted1;
    String encrypted2;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      encrypted1 =
          await Encipher.encrypt("123456", type: EncryptType.STANDARD, salt: "ABC", repeat: 14);
      encrypted2 = await Encipher.encrypt("123456", type: EncryptType.CHUANGDUN, repeat: 14);
      print(encrypted1);
      print(encrypted2);
    } on PlatformException {
      encrypted1 = 'Failed to encrypt string.';
      encrypted2 = 'Failed to encrypt string.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _encrypted = encrypted1 + "--" + encrypted2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('RESULT : $_encrypted\n'),
        ),
      ),
    );
  }
}
