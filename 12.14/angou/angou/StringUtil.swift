//
//  StringUtil.swift
//  costpang
//
//  Created by FENGBOLAI on 15/8/16.
//  Copyright (c) 2015年 FENGBOLAI. All rights reserved.
//

import Foundation

// 国际化字符串
public func LocaleString(_ key: String) -> String{
    return NSLocalizedString(key, comment: "")
}

class StringUtil: NSObject{
    
    static func isEmpty(_ str: String?) -> Bool{
        if str == nil || str == ""
        {
            return true
        }
        return false
    }
    
    /**
     获取当前时间字符串
     
     - returns:
     */
    static func currentDateString() -> String{
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd HH:mm"
        return formater.string(from: date)
    }
    
    // 检测输入字符串是否包含字母
    static func isContainChar(_ str: String) -> Bool{
        for char in str.utf8 {
            if (char > 64 && char < 91) || (char > 96 && char < 123) {
                return true
            }
        }
        return false
    }
    
    // 26位随机数字
    static func randomStringWithLength() -> String {
        let NUMBER_OF_CHARS:Int = 26
        //let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let letters : NSString = "0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: NUMBER_OF_CHARS)
        
        for _ in 0 ..< NUMBER_OF_CHARS{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return "\(randomString)"
    }
    
    // 字典转为json
    static func dicToJson(_ dic: NSMutableDictionary) -> String{
        do{
            let jsonData:Data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            let str = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
            return str
        }
        catch{
            return ""
        }
    }
    
    // json转换为字典
    static func jsonToDic(_ jsonString:String) -> NSDictionary{
        let jsonData = jsonString.data(using: String.Encoding.utf8) as Data?
        
        if let jsonData = jsonData{
            do{
                let dic = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                return dic
            }
            catch{
                
            }
        }
        
        return NSDictionary()
    }
    
    
    //JSONString
    
    // 对象数组转换为json
    
    // json转换为对象
    
    // json转换为对象数组
    
    // 待删除线的字符串
    static func getDeleteLineText(_ text: String) -> NSAttributedString{
        let attributedText = NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName: 1])  //0 表示不显示删除线，1 表示显示删除线。
        return attributedText
    }
    
    // 获取随机日期字符串
    static func getRadomDater() ->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssss"
        return formatter.string(from: Date())
    }
    
    // “      45秒” 转化为 "45秒      “
    static func transformSpaceTagInRight(_ text: String) -> String{
        let trimedText = text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        
        let length = text.lengthOfBytes(using: String.Encoding.utf8)
        let trimedTextLength = trimedText.lengthOfBytes(using: String.Encoding.utf8)
        var newText: String = trimedText
        
        for _ in 0 ..< (length - trimedTextLength){
            newText = newText + " "
        }
        return newText
    }
    
    // "45秒      “ 转化为 “      45秒”
    static func transformSpaceTagInLeft(_ text: String) -> String{
        let trimedText = text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        
        let length = text.lengthOfBytes(using: String.Encoding.utf8)
        let trimedTextLength = trimedText.lengthOfBytes(using: String.Encoding.utf8)
        var newText: String = trimedText
        var space = ""
        for _ in 0 ..< (length - trimedTextLength){
            space = space + " "
        }
        newText = space + newText
        return newText
    }
    
    
    // 获取随机日期字符串
    static func encodeUrl(_ url: String) ->String{
        let escapedUrl = CFURLCreateStringByAddingPercentEscapes(
            nil,
            url as CFString!,
            nil,
            "!*^<>'();:@&=+$,/?%#[]{|}" as CFString!,
            CFStringBuiltInEncodings.UTF8.rawValue
        ) as String
        return escapedUrl
    }

    
}
