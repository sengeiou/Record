//
//  FDAppInfoManager.swift
//  
//
//  Created by WANG DONG on 2019/1/5.
//

import UIKit

struct FDAppInfoManager {
    
   static let ITMSSERVICESURl:String = "itms-services://?action=download-manifest&url="
    
    /// Get user major Version
    ///
    /// - Returns: The user major Versiion
    static func getMajorVersion() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        var majorVersion :String? = infoDictionary? ["CFBundleShortVersionString"] as? String//主程序版本号
        majorVersion = String(format: "V%@", majorVersion!)
        return majorVersion!
    }
    
}
