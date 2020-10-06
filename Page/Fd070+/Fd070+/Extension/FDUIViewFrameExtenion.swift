//
//  UIView+Frame.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/5/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

extension UIView {

    // x
    var x: CGFloat {

        get {

            return frame.origin.x
        }

        set(newVal) {

            var tmpFrame: CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }

    // y
    var y: CGFloat {

        get {

            return frame.origin.y
        }

        set(newVal) {

            var tmpFrame: CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }

    // height
    var height: CGFloat {

        get {

            return frame.size.height
        }

        set(newVal) {

            var tmpFrame: CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }

    // width
    var width: CGFloat {

        get {

            return frame.size.width
        }

        set(newVal) {

            var tmpFrame: CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }

    // left
    var left: CGFloat {

        get {

            return x
        }

        set(newVal) {

            x = newVal
        }
    }

    // right
    var right: CGFloat {

        get {

            return x + width
        }

        set(newVal) {

            x = newVal - width
        }
    }

    // top
    var top: CGFloat {

        get {

            return y
        }

        set(newVal) {

            y = newVal
        }
    }

    // bottom
    var bottom: CGFloat {

        get {

            return y + height
        }

        set(newVal) {

            y = newVal - height
        }
    }
    // centerX
    var centerX: CGFloat {

        get {

            return center.x
        }

        set(newVal) {

            center = CGPoint(x: newVal, y: center.y)
        }
    }
    //centerY
    var centerY: CGFloat {

        get {

            return center.y
        }

        set(newVal) {

            center = CGPoint(x: center.x, y: newVal)
        }
    }
    // middleX
    var middleX: CGFloat {

        get {

            return width / 2
        }
    }
    // middleY
    var middleY: CGFloat {

        get {

            return height / 2
        }
    }
    // middlePoint
    var middlePoint: CGPoint {

        get {

            return CGPoint(x: middleX, y: middleY)
        }
    }
}