//
//  WorkOutResultModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct WorkOutResultModel {
    var date = ""
    var title = ""
    var value = ""
    var workOutResultItemModels = [WorkOutResultItemModel]()
}

struct WorkOutResultItemModel {
    var type = WorkOutResultType.heartRate
    var mainColor = UIColor.white
    var icon = ""
    var value = ""
    var unit = ""
    //心率的代表： -1代码没值。 -2代表有值。 其他正常表示进度。
    var progress: CGFloat = 0
    var describe = ""
}

enum WorkOutResultType {
    case heartRate
    case calorie
    case schedule
    case distance
}
