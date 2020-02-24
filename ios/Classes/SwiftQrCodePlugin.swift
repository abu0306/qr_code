import Flutter
import UIKit

public class SwiftQrCodePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        
       let factory = QrReaderViewFactory(registrar: registrar)
        registrar.register(factory, withId: "me.hetian.flutter_qr_reader.reader_view")
        
        let factory1 = QrReaderViewFactory(registrar: registrar)
           registrar.register(factory1, withId: "me.hetian.flutter_qr_reader.reader_view1")
        
//        let channel = FlutterMethodChannel(name: "qr_code", binaryMessenger: registrar.messenger())
//        let instance = SwiftQrCodePlugin()
//        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}


extension UIView {
    
    // x
    @objc
    public  var x : CGFloat {
        get {
            return frame.origin.x
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x = newVal
            frame = tmpFrame
        }
    }
    
    // y
    @objc
    public var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y = newVal
            frame = tmpFrame
        }
    }
    
    // height
    @objc
    public var height : CGFloat {
        get {
            return frame.size.height
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame = tmpFrame
        }
    }
    
    // width
    @objc
    public var width : CGFloat {
        get {
            return frame.size.width
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame = tmpFrame
        }
    }
    
    
    
    // centerX
    @objc
    public var centerX : CGFloat {
        get {
            return center.x
        }
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    // centerY
    @objc
    public var centerY : CGFloat {
        get {
            return center.y
        }
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    
    /// frame.maxX
    @objc
    public var maxX: CGFloat{
        get{
            return self.frame.maxX
        }
        set{
            var r = self.frame
            r.origin.x = newValue - r.size.width
            self.frame = r
        }
        
    }
    
    /// frame.maxY
    @objc
    public var maxY: CGFloat{
        set{
            var r = self.frame
            r.origin.y = newValue - r.size.height
            
            self.frame = r
        }
        get{
            return self.frame.maxY
        }
    }
    
    @objc
    var size: CGSize{
        set{
            var r = frame
            r.size = newValue
            frame = r
        }
        get{
            return frame.size
        }
    }
}



public let KScreenW = UIScreen.main.bounds.size.width
public let KScreenH = UIScreen.main.bounds.size.height
public let KStatusHeight = UIApplication.shared.statusBarFrame.size.height

