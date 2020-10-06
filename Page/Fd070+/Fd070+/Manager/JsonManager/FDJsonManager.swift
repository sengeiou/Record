//
//  FDJsonManager.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/17.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

struct paseJsonManagerError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }
}

class FDJsonManager: NSObject {

    static func getArrayFromJSONString(jsonString:String) throws ->[String: [[String: Int]]]?{

        if let data = jsonString.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Int]]]
                return json
            } catch _  {
                throw paseJsonManagerError(message: "Parse data error")
            }
        }else {
            throw paseJsonManagerError(message: "Orinigal Data error")
        }
    }
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString: JSon String
    /// - Returns: Json Dic
   static func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    static func getJsonStringFromAnyObject(anyObject: Any) -> String {
        if (!JSONSerialization.isValidJSONObject(anyObject)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: anyObject, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }

}
