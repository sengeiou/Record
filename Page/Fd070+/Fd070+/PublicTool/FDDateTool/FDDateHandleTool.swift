//
//  FDDateHandleTool.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/25.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class FDDateHandleTool: NSObject {
    
    static var timeStamp : String {
        
        let date = Date(timeIntervalSinceNow: 0)
        let a = date.timeIntervalSince1970
        let timeStp = String.init(format: "%.f", a)
        
        return timeStp
    }
    
    static func getCurrentDate(dateType:String) -> String {
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = dateType
        
        let strNowTime = timeFormatter.string(from: date as Date) as String
        return strNowTime
    }
    
    
    //MARK: 把时间格式转换成时间戳
    static func dateStringToTimeStamp(stringTime:String,timeForm:String)->String {
        
        let dfmatter = DateFormatter()
        dfmatter.locale = Locale.init(identifier: "en-US")
        dfmatter.dateFormat = timeForm
        let date = dfmatter.date(from: stringTime) ?? Date()
        
        let dateStamp:TimeInterval = date.timeIntervalSince1970
        
        let timeStamp:Int = Int(dateStamp)
        
        return String(timeStamp)
        
    }
    
    
    /// 把时间对象转换为时间字符串
    ///
    /// - Parameters:
    ///   - date: 原始时间对象
    ///   - timeForm: 要转换成的时间格式
    /// - Returns: 转换好的日期字符串
    static func dateObjectToDateStrin(date: Date,timeForm:String)->String {
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = timeForm
        return dfmatter.string(from: date)
        
    }
    static func timestampToDateObject(timestamp: String) ->Date {
        let dfmatter = DateFormatter()
        return dfmatter.date(from: timestamp) ?? Date()
    }
    
    
    /// Cover timeStamp to date string
    ///
    /// - Parameters:
    ///   - timeStampStr: The original timeStamp string
    ///   - formatStr: The time format string
    /// - Returns: The date string
    static func coverTimeStampToDateStr(timeStampStr: String, formatStr: String) -> String {
        
        if timeStampStr == "0" || timeStampStr.isEmpty {
            return ""
        }
        
        let dfmatter = DateFormatter()
        //        dfmatter.locale = Locale.init(identifier: "en-US")
        dfmatter.dateFormat = formatStr
        let date = Date(timeIntervalSince1970: Double(timeStampStr)!)
        let dateStr = dfmatter.string(from: date)
        return dateStr
    }
}
