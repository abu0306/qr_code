//
//  QRCode.swift
//  QRCode
//
//  Created by 李广斌 on 2018/12/13.
//  Copyright © 2018年 李广斌. All rights reserved.
//

import UIKit
import AVFoundation
import Flutter

class QRCodeTool: NSObject {
    
    /// 扫描中心识别区域范围 (内边框)
    var scanInsideFrame = UIScreen.main.bounds
    
    /// 扫描中心识别区域范围 (外边框)
    var scanOutsideFrame = UIScreen.main.bounds
    
    /// 相机可见视图
    var preview: UIView?
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    fileprivate var _channel: FlutterMethodChannel?
    
    fileprivate lazy var session: AVCaptureSession? = {
        
        /// 获取设备
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {return nil}
        /// 创建输入流
        guard let input = try? AVCaptureDeviceInput(device: device) else {return nil}
        /// 创建二维码
        let output = AVCaptureMetadataOutput.init()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        /*
         设置采集扫描区域的比例 默认全屏是（0，0，1，1）
         rectOfInterest 填写的是一个比例，输出流视图preview.frame为 x , y, w, h, 要设置的矩形快的scanFrame 为 x1, y1, w1, h1. 那么rectOfInterest 应该设置为 CGRectMake(y1/y, x1/x, h1/h, w1/w)。
         rectOfInterest 坐标原点 右上角
         */
        
        let x = scanInsideFrame.minY / (self.preview?.height ?? 1)
        let y = (UIScreen.main.bounds.width - scanInsideFrame.maxX) / (self.preview?.width ?? 1)
        let width = scanInsideFrame.height / (self.preview?.height ?? 1)
        let height = scanInsideFrame.width / (self.preview?.width ?? 1)
        
        output.rectOfInterest = CGRect(x: x, y: y, width: width , height: height)
        
        // 创建环境光感输出流
        let lightOutput = AVCaptureVideoDataOutput.init()
        lightOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        let one = AVCaptureSession.init()
        //高质量采集率
        one.sessionPreset = AVCaptureSession.Preset.high
        one.addInput(input)
        one.addOutput(output)
        one.addOutput(lightOutput)
        
        output.metadataObjectTypes = [
            AVMetadataObject.ObjectType.qr,
            AVMetadataObject.ObjectType.ean13,
            AVMetadataObject.ObjectType.ean8,
            AVMetadataObject.ObjectType.code128
        ]
        return one
    }()
    
    /// 初始化扫描空间
    ///
    /// - Parameters:
    ///   - preview: 相机图像展示view
    ///   - scanInsideFrame: 扫描区域内边框
    ///   - scanOutsideFrame: 扫描区域外边框
    public init(_ channel:FlutterMethodChannel?, _ preview:UIView,_ scanInsideFrame: CGRect,_ scanOutsideFrame: CGRect) {
        super.init()
        _channel = channel
        if  cameraAuthorLicense() == false {  return  }
        
        self.preview = preview
        self.scanInsideFrame = scanInsideFrame
        self.scanOutsideFrame = scanOutsideFrame
        configuredScan()
    }
    
    /// 开启扫描
    public func startRunning() {
        session?.startRunning()
    }
    
    /// 停止扫描
    public func stopRunning() {
        session?.stopRunning()
    }
    
    //配置初始化采集配置信息
    fileprivate func configuredScan() {
        guard let session = session else { return }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = self.preview?.bounds ?? CGRect.zero
        guard let p = previewLayer else {  return  }
        preview?.layer.insertSublayer(p, at: 0)
    }
}


extension QRCodeTool {
    
    /// 识别图片二维码
    public func scanImageQRCode(_ image: UIImage?) {
        
        // 00判断是不是模拟器
        if QRCodeTool.isSimulator() {
            //            Toast.show(msg: "当前您运行的是模拟器上面、模拟器是无法使用相机")
            return
        }
        
        guard let image = image else { return }
        let detector = CIDetector(ofType:
            CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [
                                    CIDetectorAccuracy:CIDetectorAccuracyHigh,
        ])
        
        guard let cgImage = image.cgImage else {  return   }
        guard let features = detector?.features(in: CIImage.init(cgImage: cgImage)) else {return}
        
        if features.count >= 0{
            
            if let feature = features.first as? CIQRCodeFeature {
                if feature.messageString?.isEmpty == false {
                    self.stopRunning()
                    /// 扫描结果
                    _channel?.invokeMethod("qrcode_result", arguments: feature.messageString )
                }
            }
        }
    }
}

extension QRCodeTool: AVCaptureMetadataOutputObjectsDelegate {
    //扫描完成后执行
    final func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let o = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return  }
        
        if o.stringValue?.isEmpty == false {
            self.stopRunning()
            _channel?.invokeMethod("qrcode_result", arguments: o.stringValue)
            //            self.reseponsedQRResult?(o.stringValue ?? " ")
        }
    }
}

extension QRCodeTool {
    func cameraAuthorLicense() -> Bool {
        // 1:如果用户第一次拒绝了不允许了访问相册，提示用户
        let mediaType = AVMediaType.video
        let authStatus = AVCaptureDevice .authorizationStatus(for: mediaType)
        if authStatus == .restricted || authStatus == .denied {
            _channel?.invokeMethod("qrcode_restricted", arguments: true)
            return false
        }
        return true
    }
}


extension QRCodeTool: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //扫描过程中执行，主要用来判断环境的黑暗程度
    final func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
}

extension QRCodeTool {
    
    // 判断是否是模拟器：如果是模拟器返回true
    fileprivate class func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
    
}


