//
//  WorkoutHistoryModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/11.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct WorkoutHistoryModel {
    var summaryModel = WorkoutHistorySummaryModel()
    var detailModels = [WorkoutHistoryDetailModel]()
}

struct WorkoutHistorySummaryModel {
    var summaryDistance = ""
    var monthDate = ""
}

struct WorkoutHistoryDetailModel {
    var type = ""
    var distance = ""
    var schedule = ""
    var step = ""
    var calorie = ""
    var dayDate = ""
}
