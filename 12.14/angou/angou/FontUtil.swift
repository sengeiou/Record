//
//  UIFontUtil.swift
//  costpang
//
//  Created by FENGBOLAI on 15/8/13.
//  Copyright (c) 2015年 FENGBOLAI. All rights reserved.
//

import UIKit

class FontUtil {
    
    static func smallFont() -> UIFont{
        let font = UIFont(name: "Heiti SC", size: 8.0)
        return font!
    }
    
    static func normalFontNotBold() -> UIFont{
        let font = UIFont(name: "Helvetica", size: 12.0)
        return font!
    }
    
    static func middleFontNotBold() -> UIFont{
        let font = UIFont(name: "Helvetica", size: 14.0)
        return font!
    }
    
    static func biggerFont() -> UIFont{
        let font = UIFont(name: "Helvetica", size: 16.0)
        return font!
    }
    
    static func biggestFont() -> UIFont{
        let font = UIFont(name: "Helvetica", size: 18.0)
        return font!
    }
    
    //=======以下为加粗字体===========
    static func normalFont() -> UIFont{
        let font = UIFont(name: "Helvetica-Bold", size: 12.0)
        return font!
    }
    
    static func middleFont() -> UIFont{
        let font = UIFont(name: "Helvetica-Bold", size: 14.0)
        return font!
    }
    
    static func bigBoldFont() -> UIFont{
        let font = UIFont(name: "Helvetica-Bold", size: 16.0)
        return font!
    }
    
    static func biggestBoldFont() -> UIFont{
        let font = UIFont(name: "Helvetica-Bold", size: 18.0)
        return font!
    }

    static func giantFont() -> UIFont{
        let font = UIFont(name: "Helvetica-Bold", size: 60.0)
        return font!
    }
    
    
}
