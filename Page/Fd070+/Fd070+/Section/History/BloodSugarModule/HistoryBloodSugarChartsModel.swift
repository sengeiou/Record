//
//  HistoryBloodSugarChartsModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct HistoryBloodSugarChartsModel {

    var date = ""
    var value = ""
    var unit = ""
    var values = [HistoryBloodSugarValueModel]()

}

struct HistoryBloodSugarValueModel {

    var xValue: String = ""
    var yValue: CGFloat = 0


    init(_ xValue: String , _ yValue: CGFloat) {
        self.xValue = xValue
        self.yValue = yValue
    }
}

enum HistoryBloodSugarLoadDataDirectionType: Int {

    case ahead = 0
    case current
    case next

}
