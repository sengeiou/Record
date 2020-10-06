//
//  HistoryBloodSugarChartsManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct HistoryBloodSugarChartsManager {

    private static var calendar: Calendar = {
        var  calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar
    }()

    private static var components: DateComponents = {
        return Calendar.current.dateComponents([.year, .day , .month], from: Date())
    }()
    
    /// Get bloodSugar model data
    ///
    /// - Parameter loadDataDirectionType: The load data direction
    /// - Returns: The bloodSugar model
    static func getHistoryBloodSugarChartsModel(loadDataDirectionType: HistoryBloodSugarLoadDataDirectionType = .current) -> HistoryBloodSugarChartsModel {

        var model = HistoryBloodSugarChartsModel()
         //只有日模式。就只有12柱
        let dataCount = 12

        switch loadDataDirectionType {
        case .next:
            components.day! += 1
        case .ahead:
            components.day! -= 1
        default:
            break
        }
        
        let date = calendar.date(from: components)!
        model.date = converseDateToDateString(date: date, dateFormat: "yyyy/MM/dd")

        var bloodSugarValueModels = [HistoryBloodSugarValueModel]()

        for _ in 0 ..< dataCount {

            _ = Int.random(in: 1 ... 3)
//            let value = HistoryBloodSugarValueModel.init("", CGFloat(yValue))
            let value = HistoryBloodSugarValueModel.init("", 0)

            bloodSugarValueModels.append(value)
        }
        model.values = bloodSugarValueModels

        model.value = (bloodSugarValueModels.last?.yValue.description)!

        return model
    }
    static func getBloodSugarString(_ bloodSugarOriginalValue: CGFloat) -> String {

        if bloodSugarOriginalValue == 1 {
            return  "MydayVC_bloodSugarValue_low".localiz()
        }else if bloodSugarOriginalValue == 2 {
            return "MydayVC_bloodSugarValue_normal".localiz()
        }else if bloodSugarOriginalValue == 3 {
            return "MydayVC_bloodSugarValue_high".localiz()
        }
        return ""
    }
}
extension HistoryBloodSugarChartsManager {

    /// Cover date object to date string
    ///
    /// - Parameters:
    ///   - date: The date object
    ///   - dateFormat: The coverse dateFormat
    /// - Returns: The date string
    private static func converseDateToDateString(date: Date, dateFormat: String) -> String {

        let dfmatter = DateFormatter()
        dfmatter.dateFormat = dateFormat
        let dateStr = dfmatter.string(from: date)
        return dateStr
    }
}
