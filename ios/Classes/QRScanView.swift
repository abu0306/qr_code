//
//  QRScanView.swift
//  QRCode
//
//  Created by 李广斌 on 2018/12/14.
//  Copyright © 2018年 李广斌. All rights reserved.
//

import UIKit

class QRScanView: UIImageView {
    
    //// 二维码扫描范围
    var scanFrame : CGRect {
        var originalFrame = frame
//        originalFrame.origin.x += CGFloat(7).switchValue()
//        originalFrame.origin.y += CGFloat(50).switchValue()
//        originalFrame.size.width -= CGFloat(14).switchValue()
//        originalFrame.size.height = originalFrame.width
        return originalFrame
    }
    
    init(image: UIImage? ,_ x : CGFloat, y: CGFloat) {
        var cgrect = CGRect.zero
        if let size = image?.size  {
            var newFrame = CGRect(origin: CGPoint(x: x, y: y), size: size)
            newFrame.origin.x = newFrame.origin.x.switchValue()
            newFrame.origin.y = newFrame.origin.y.switchValue()
            newFrame.size = CGSize(
                width: UIScreen.main.bounds.width - 2 * newFrame.origin.x ,
                height: size.height * (UIScreen.main.bounds.width - 2 * newFrame.origin.x) / size.width
            )
            cgrect = newFrame
        }
        super.init(frame: cgrect)
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension CGFloat {
    func switchValue() -> CGFloat {
        return self * UIScreen.main.bounds.width / 375
    }
}

