//
//  QrReaderViewController.swift
//  photo_camera
//
//  Created by 李广斌 on 2020/2/14.
//

import UIKit
import Flutter

class QrReaderViewController: NSObject,FlutterPlatformView {
    
    var _qrcodeview = UIView()
    
    var qrCodeTool: QRCodeTool?
    
    var _channle:FlutterMethodChannel?
    
    func view() -> UIView {
        return _qrcodeview
    }
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?,binaryRegistrar:FlutterPluginRegistrar) {
        super.init()
        
        print("viewId:---",viewId)
        
        guard let params = args as? [String:CGFloat] else { return  }
        
        let width = params["width"] ?? 0
        let height = params["height"] ?? 0
        let qr_code_x = params["qr_code_x"] ?? 0
        let qr_code_y = params["qr_code_y"] ?? 0
        let qr_code_width = params["qr_code_width"] ?? 0
        let qr_code_height = params["qr_code_height"] ?? 0
        
        _qrcodeview.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        
        _channle = FlutterMethodChannel(name: "me.hetian.flutter_qr_reader.reader_view_\(viewId)" , binaryMessenger: binaryRegistrar.messenger())
        
        _channle?.setMethodCallHandler { (call, result) in
            
            print("回调方法:-----",call.method)
        }
        
        _channle?.invokeMethod("native", arguments: "返回数据")
        
        //       let channel = FlutterMethodChannel(name: "flutter/qrcode_\(viewId)", binaryMessenger: binaryRegistrar.messenger())
        //
        
        let v = UIView(frame: CGRect(x: qr_code_x, y: qr_code_y, width: qr_code_width, height: qr_code_height))
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        _qrcodeview.addSubview(v)
        
        qrCodeTool = QRCodeTool(_channle, _qrcodeview, CGRect(x: qr_code_x, y: qr_code_y, width: qr_code_width, height: qr_code_height), CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        
        //        qrCodeTool = QRCodeTool(_qrcodeview, CGRect(x: qr_code_x, y: qr_code_y, width: qr_code_width, height: qr_code_height), CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        qrCodeTool?.startRunning()
    }
}


