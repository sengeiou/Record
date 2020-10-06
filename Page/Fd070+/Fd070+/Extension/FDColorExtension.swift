//
//  ColorExtension.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/11.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class var randomColor: UIColor {
        return UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 0.4)
    }
    
    static func hexColor(_ hexColor : Int64) -> UIColor {
        
        let red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0;
        let green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0;
        let blue = ((CGFloat)(hexColor & 0xFF))/255.0;
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // MARK:- Color RGB
    static func RGB (r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    


    var lighterColor: UIColor {
        return lighterColor(removeSaturation: 0.5, resultAlpha: -1)
    }

    fileprivate func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}

        return UIColor(hue: h,
                       saturation: max(s - val, 0.0),
                       brightness: b,
                       alpha: alpha == -1 ? a : alpha)
    }
    
}
