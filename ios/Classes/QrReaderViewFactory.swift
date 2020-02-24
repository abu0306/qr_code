//
//  QrReaderViewFactory.swift
//  photo_camera
//
//  Created by 李广斌 on 2020/2/14.
//
import Flutter
import UIKit

class QrReaderViewFactory: NSObject,FlutterPlatformViewFactory {
    
    var _registrar:FlutterPluginRegistrar
    
    init(registrar:FlutterPluginRegistrar) {
        _registrar = registrar
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let one = QrReaderViewController(withFrame: frame, viewIdentifier: viewId, arguments: args,binaryRegistrar:_registrar)
        return one
    }
        
}
