//
//  HistroySportChartsModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/13.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct HistorySportChartsModel {

    var type = SportType.none
    var date = ""
    var value = ""
    var unit = ""
    var summaryType = HistorySportSummaryType.day
    var values = [SportValueModel]()


}
enum SportType: Int {

    case walk
    case target
    case sportTime
    case calorie
    case distance
    case none

    init(rawValue: Int) {

        if rawValue == 0 {
            self = .walk
        }else if rawValue == 1 {
            self = .target
        }else if rawValue == 2 {
            self = .sportTime
        }else if rawValue == 3 {
            self = .calorie
        }else if rawValue == 4 {
            self = .distance
        }else  {
            self = .none
        }
    }

}

enum HistorySportSummaryType {
    case day
    case month
    case year
}

enum HistorySportLoadDataDirectionType: Int {

    case ahead = 0
    case current
    case next

}

struct SportValueModel {
    
    var xValue: String = ""
    var yValue: CGFloat = 0

}


