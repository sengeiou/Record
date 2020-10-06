//
//  FDSleepDetailManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/2/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

protocol FDSleepDetailDataSource {
    
    
    /// 实现外部数据处理成画图需要的数据源
    ///
    /// - Returns: 返回FDSleepDetailOriginalModel 包含一级数据处理以及睡眠详情的model
    func FDSleepdetailDataSource(_ dateStr:String) -> FDSleepDetailOriginalModel?
}



class FDSleepDetailManager: NSObject {


    private static var calendar: Calendar = {
        var  calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar
    }()

    private static var components: DateComponents = {
        return Calendar.current.dateComponents([.year, .day , .month], from: Date())
    }()


    static func getSleepQueryDateStr(summaryType: HistorySportSummaryType,loadDataDirectionType: FDSleepLoadDataDirectionType, specifyDateStr: String) -> String {


        var dateString = ""
        switch summaryType {
        case .day:
            if loadDataDirectionType == .next {
                components.day! += 1
            }else if loadDataDirectionType == .ahead {
                components.day! -= 1
            }
             dateString = converseDateToDateString(date: calendar.date(from: components)!, dateFormat: "yyyy/MM/dd")
        case .month:
            if loadDataDirectionType == .next {
                components.month! += 1
            }else if loadDataDirectionType == .ahead {
                components.month! -= 1
            }
             dateString = converseDateToDateString(date: calendar.date(from: components)!, dateFormat: "yyyy/MM")
        case .year:
            if loadDataDirectionType == .next {
                components.year! += 1
            }else if loadDataDirectionType == .ahead {
                components.year! -= 1
            }

             dateString = converseDateToDateString(date: calendar.date(from: components)!, dateFormat: "yyyy")
        }


        return dateString


    }


    /// 根据睡眠详情得出分段的睡眠详情 -- 日详情
    ///
    /// - Parameter sleepDetailOriginalModel: 包含睡眠详情数据的原始Model
    /// - Returns: 返回绘图需要的数据
    static func getSleepSectionData(_ sleepDetailOriginalModel:FDSleepDetailOriginalModel) -> FDSleepDetailSummaryModel {
       
        var sleepResultArray = [FDSleepDetailModel]()
        
        if sleepDetailOriginalModel.sleepDetailArray.count>0 {
            
            var sleepDetailModel = FDSleepDetailModel()
            for (index,value) in sleepDetailOriginalModel.sleepDetailArray.enumerated() {

                let lastTime = Int(value.sleepDate! / 60) * 60
                
//                print("下标:\(index)---内容：\(value)")

                if index < sleepDetailOriginalModel.sleepDetailArray.count - 1 {
                    
                    let nextTime = Int(sleepDetailOriginalModel.sleepDetailArray[index+1].sleepDate! / 60) * 60
                    
                    if (value.sleepType! == sleepDetailOriginalModel.sleepDetailArray[index+1].sleepType!) && (nextTime - lastTime == 60) {
                        
                        sleepDetailModel.sleepStartTime = (sleepDetailModel.sleepStartTime == 0 ? value.sleepDate! : sleepDetailModel.sleepStartTime)
                    }
                    else
                    {
                        sleepDetailModel.sleepStartTime = (sleepDetailModel.sleepStartTime == 0 ? value.sleepDate! : sleepDetailModel.sleepStartTime)
                        sleepDetailModel.sleepEndTime = value.sleepDate!
                        sleepDetailModel.sleepType = value.sleepType
                        sleepResultArray.append(sleepDetailModel)
                        sleepDetailModel = FDSleepDetailModel()
                    }
                }
                else
                {
                    sleepDetailModel.sleepStartTime = (sleepDetailModel.sleepStartTime == 0 ? value.sleepDate! : sleepDetailModel.sleepStartTime)
                    sleepDetailModel.sleepType =  value.sleepType
                    sleepDetailModel.sleepEndTime = value.sleepDate!
                    sleepResultArray.append(sleepDetailModel)
                    sleepDetailModel = FDSleepDetailModel()
                }
                
            }
            
//            print("sleep result Data:::\(sleepResultArray)")
        }
        
        var sleepSummaryDetailModel:FDSleepDetailSummaryModel = FDSleepDetailSummaryModel()
        sleepSummaryDetailModel.sleepEnd = sleepDetailOriginalModel.sleepEnd
        sleepSummaryDetailModel.sleepStart = sleepDetailOriginalModel.sleepStart
        sleepSummaryDetailModel.sleepDeepCount = sleepDetailOriginalModel.sleepDeepCount
        sleepSummaryDetailModel.sleepLightCount = sleepDetailOriginalModel.sleepLightCount
        sleepSummaryDetailModel.sleepSoberCount = sleepDetailOriginalModel.sleepSoberCount
        sleepSummaryDetailModel.sleepTotalCount = sleepDetailOriginalModel.sleepTotalCount
        sleepSummaryDetailModel.date = sleepDetailOriginalModel.date
        sleepSummaryDetailModel.values = sleepResultArray
        
        return sleepSummaryDetailModel
    }
    
    
    
    static func creatDisplayViewData(model:FDSleepDayDetailModel) -> FDSleepDiffColorLayer {
        
        var layerModel = FDSleepDiffColorLayer()
        layerModel.deepColor = UIColor.red
        layerModel.lightColor = UIColor.yellow
        layerModel.soberColor = UIColor.brown
        
        let sleepTotal = model.sleepDeepTotal + model.sleepLightTotal + model.sleepsoberTotal
        
        layerModel.deepProportion = Double(model.sleepDeepTotal)/Double(sleepTotal)
        layerModel.lightProportion = Double(model.sleepLightTotal)/Double(sleepTotal)
        layerModel.soberProportion = Double(model.sleepsoberTotal)/Double(sleepTotal)

        return layerModel
        
    }

  
    static func getSleepDuration(_ originalValue: Int) -> String {

        let sportTimeHour = Int(originalValue) / 60
        let sportTimeMinute = Int(originalValue) % 60
        let description = sportTimeHour.description + "h" + "" + sportTimeMinute.description + "m"

        return description

    }


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
