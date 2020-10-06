//
//  HistroryCalendarModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/19.
//  Copyright © 2019年 WANG DONG. All rights reserved.
//

import Foundation

struct HistroyCalendarModel {

    var dayModels = [DayModel]()

    var currentDay = 0       //当前是几号
    var thisMonthDayNum = 0    //当前月有多少天
    var thisYear = 0          //当前的年份
    var thisMonth = 0         //当前的月份
    var thisWeekFirstDay = 0   //当前一号是周几
    var thisMonthWeekNum = 0   //当前月有几周

}
class DayModel {
    var dayNumber = ""
    var isHaveRecord = false
    var isToday = false
}

enum HistroyCalendarLoadDataDirectionType: Int {

    case ahead = 0
    case current
    case next

}
