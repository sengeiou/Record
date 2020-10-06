//
//  CommonUtil.swift
//  costpang
//
//  Created by FENGBOLAI on 15/8/31.
//  Copyright (c) 2015年 FENGBOLAI. All rights reserved.
//

import UIKit
class Constants:NSObject{
    
    /* 屏幕宽度 */
    static let WIDTH_SCREEN = UIScreen.main.bounds.width
    
    /* 屏幕高度 */
    static let HEIGHT_SCREEN = UIScreen.main.bounds.height
    
    // 微信
    static let WX_APP_ID = "wx05c1961b0e7ea730"
    
    static let WX_GZH_APP_ID = "wx1fd29f609eee9834"
    
    
    
    /* host:port 路径 */
    static func hostAndPortURL() -> String {
        return "http://www.costpang.com"
        //return "http://localhost:8090"
    }
    
    

    
}
