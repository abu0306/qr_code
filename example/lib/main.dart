import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qr_code/qr_code.dart';
import 'package:qr_code_example/scan_page.dart';
import 'package:qr_code/qr_code_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
//    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await QrCode.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "scanPage": (context) => ScanPage(),
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(("二维码扫描")),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 300,
            height: 200,
            child: UiKitView(
                viewType: "me.hetian.flutter_qr_reader.reader_view1",
                onPlatformViewCreated: (val) {
                  print("dart view id1 + ${val}");
                }),
          ),
          FlatButton(
            child: Text("跳转"),
            onPressed: () {
              Navigator.pushNamed(context, "scanPage");
            },
          ),
          QrCodeView(100,100,100,100,100,100),
        ],
      ),
    );
  }
}
