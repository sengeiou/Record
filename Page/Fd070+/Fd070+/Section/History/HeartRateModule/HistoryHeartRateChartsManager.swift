//
//  HeartRateManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct HistoryHeartRateChartsManager {
    
    private static var calendar: Calendar = {
        var  calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar
    }()
    
    private static var components: DateComponents = {
        return Calendar.current.dateComponents([.year, .day , .month], from: Date())
    }()
    

    /// Get heartRate model data
    ///
    /// - Parameter loadDataDirectionType: The load data direction
    /// - Returns: The heartRate data
    static func getHistoryHeartRateChartsModelFromDB(loadDataDirectionType: HistroyHeartRateLoadDataDirectionType = .current) -> HistoryHeartRateChartsModel {

        var model = HistoryHeartRateChartsModel()

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

        model.unit = "BPM"

        var heartRateValueModels = [HistoryHeartRateValueModel]()

        let dataHRArray = try? DailyDetailDataHelper.findHRData(date: model.date, macAddress: CurrentMacAddress)

        let startOfDayTimeStamp = Int(date.startOfDay.timeIntervalSince1970)

        for model in dataHRArray! {


            let timeStampInt = Int(model.timeStamp) ?? 0
            let schudle = (timeStampInt - startOfDayTimeStamp ) / 60

            let value = HistoryHeartRateValueModel.init(xValue: schudle.description, yValue: model.hr.toCGFloat())

            heartRateValueModels.append(value)
        }
        model.values = heartRateValueModels

        model.value = (heartRateValueModels.last?.yValue.description) ?? "0"
        return model

    }
}

extension HistoryHeartRateChartsManager {
    
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

