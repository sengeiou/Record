//
//  HistoryModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

enum HistorySummaryDataType: Int {
    case day = 0
    case month
    case year

    init(rawValue: Int) {

        if rawValue == 0 {
            self = .day
        }else if rawValue == 1 {
            self = .month
        }else {
           self = .year
        }
    }

}

struct HistoryChartModel {

    var summaryDataType = HistorySummaryDataType.day
    var date = ""

    var chartModel = ChartModel()

}


/// 判断前天有无数据表的Model。
struct HistroyDataFlagModel: Encodable {
    var timeStamp = ""
    var userId = ""
    var btMac = ""

    var dataFlag = ""
}
