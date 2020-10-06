//
//  WorkoutInforModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct WorkoutInforModel {
    var type = ""
    var state = ""
    var value = ""

    var distance = ""
    var step = ""
    var durationSecond = ""
    var calorie = ""
    var hearRate = ""
}
enum WorkoutType {
    case walk
    case run
}
enum WorkoutState {
    case start
    case pause
    //continue
    case goOn
    case end
}


