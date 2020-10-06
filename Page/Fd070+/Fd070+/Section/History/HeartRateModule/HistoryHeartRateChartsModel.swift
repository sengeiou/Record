//
//  HeartRateModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct HistoryHeartRateChartsModel {
    var date = ""
    var value = ""
    var unit = ""
    var values = [HistoryHeartRateValueModel]()

}

struct HistoryHeartRateValueModel {

    var xValue: String = ""
    var yValue: CGFloat = 0


}

enum HistroyHeartRateLoadDataDirectionType: Int {

    case ahead = 0
    case current
    case next

}

