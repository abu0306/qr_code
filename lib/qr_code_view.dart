import 'package:flutter/material.dart';
import 'dart:io';

class QrCodeView extends StatefulWidget {
  /// 扫描可视宽度
  final double width;

  /// 扫描可视宽高
  final double height;

  /// 扫描区域宽
  final double qrCodeWidth;

  /// 扫描区域高
  final double qrCodeHeight;

  /// 扫描区域X值
  final double qrCodeX;

  /// 扫描区域Y值
  final double qrCodeY;

  QrCodeView(this.width, this.height, this.qrCodeWidth, this.qrCodeHeight,
      this.qrCodeX, this.qrCodeY);

  @override
  _QrCodeViewState createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Container(
        child: Text("iOS 系统"),
      );
    } else if (Platform.isAndroid) {
      return Container(
        child: Text("Android 平台"),
      );
    } else {
      return Container(
        child: Text("不支持平台"),
      );
    }
  }
}
