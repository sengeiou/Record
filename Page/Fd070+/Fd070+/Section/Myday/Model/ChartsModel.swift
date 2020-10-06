//
//  ChartsModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/19.
//  Copyright © 2019年 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct ChartModel {
    
    var type = MydayModel.TypeEnum.none
    var value = ""
    var unit = ""
    var descModel = [DescModel]()
    
}

struct DescModel {
    var xValue: String = ""
    var points = [PointModel]()
    
    init() {
        
    }
    init(_ xValue: String , _ points: [PointModel]) {
        self.xValue = xValue
        self.points = points
    }
}

struct PointModel {
    
    var type = PointType.none
    var yValue: CGFloat = 0
    
    init() {
        
    }
    init(_ type: PointType , _ yValue: CGFloat) {
        self.type = type
        self.yValue = yValue
    }
    
}

enum PointType {
    
    case deepSleepSummary
    case lightSleepSummary
    case awakeSummary
    
    case normalSleep

    //连续定时自动测量的
    case heatRateAutomatic
    //手动测量的
    case heatRateManual
    
    case none
    
    init(rawValue: Int) {
        
        if rawValue == 0 {
            self = .deepSleepSummary
        }else if rawValue == 1 {
            self = .lightSleepSummary
        }else if rawValue == 2 {
            self = .awakeSummary
        }else {
            self = .normalSleep
        }
    }
}

