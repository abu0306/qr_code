import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code/qr_code_view.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  /// 扫描范围X值
  double _x = 100;

  /// 扫描范围Y值
  double _y = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: LayoutBuilder(
          builder: (context, constrains) {
            return UiKitView(
                viewType: "me.hetian.flutter_qr_reader.reader_view",
                creationParams: {
                  "width": constrains.maxWidth,
                  "height": constrains.maxHeight,
                  "qr_code_width": constrains.maxWidth - 2 * _x,
                  "qr_code_height": constrains.maxWidth - 2 * _x,
                  "qr_code_x": _x,
                  "qr_code_y": _y,
                },
                creationParamsCodec: const StandardMessageCodec(),
                onPlatformViewCreated: (val) {
                  QRCodeController(val);
                  print("dart view id + ${val}");
                });
          },
        ),
      ),
    );
  }
}

class QRCodeController {
  final int viewId;
  final MethodChannel _channel;

  Future _handler(MethodCall call) async {
    print(call.method);
    if (call.method == "qrcode_result") {

      print("扫描结果:-------${call.arguments}");
    }

    /// 没有相机权限
    if (call.method == "qrcode_restricted"){

      if (call.arguments == true){
        print("相机权限被拒绝");
      }
      print(call.arguments);
    }
  }

  QRCodeController(this.viewId)
      : _channel =
            MethodChannel("me.hetian.flutter_qr_reader.reader_view_${viewId}") {
    _channel.setMethodCallHandler(_handler);
  }
}
