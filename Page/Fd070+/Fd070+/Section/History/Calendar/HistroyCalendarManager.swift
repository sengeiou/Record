//
//  HistroyCalendarManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/19.
//  Copyright © 2019年 WANG DONG. All rights reserved.
//

import Foundation

struct HistroyCalendarManager {

    private static var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }()
    private static var components: DateComponents = {
        return Calendar.current.dateComponents([.year, .day , .month], from: Date())
    }()
    
    static func getHistroyCalendarModel(_ loadDataDirectionType: HistroyCalendarLoadDataDirectionType = .current) ->HistroyCalendarModel? {

        switch loadDataDirectionType {
        case .next:
            components.month! += 1
        case .ahead:
            components.month! -= 1
        case .current: break
        }

        //设置正确的年月
        if components.month == 13 {
            components.month = 1
            components.year! += 1
        }else if components.month == 0 {
            components.month = 12
            components.year! -= 1
        }

        let currentDate = Calendar.current.date(from: components)
        //不查询今天以后日期的数据
        if (currentDate ?? Date()) > Date().endOfDay {
            return nil
        }

        var histroyCalendarModel = HistroyCalendarModel()

        histroyCalendarModel.currentDay = components.day!
        histroyCalendarModel.thisYear = components.year!
        histroyCalendarModel.thisMonth = components.month!

        let thisMonthDayNum = currentDate!.CalendarDays
        histroyCalendarModel.thisMonthDayNum = thisMonthDayNum

        let thisWeekFirstDay = getWeekdayWithYear(components.year!, components.month!, 1)
        histroyCalendarModel.thisWeekFirstDay = thisWeekFirstDay

        let thisMonthWeekNum = currentDate!.CalendarWeekOfMonths
        histroyCalendarModel.thisMonthWeekNum = thisMonthWeekNum

        var dayModels = [DayModel]()
        //35
        let totalDays = thisMonthWeekNum * 7
        // 1 2 ... 34 35
        for day in 1 ... totalDays {

            let dayModel = DayModel()

            let dayNumber = (day - thisWeekFirstDay + 1)
            if dayNumber < thisMonthDayNum + 1 {

                dayModel.isHaveRecord = currentDayIsHaveRecord(histroyCalendarModel.thisYear, histroyCalendarModel.thisMonth, dayNumber)
                dayModel.dayNumber = dayNumber.description

            }else {
                dayModel.dayNumber = "-1"
            }
            dayModels.append(dayModel)
        }

        histroyCalendarModel.dayModels = dayModels

        return histroyCalendarModel
    }

}

extension HistroyCalendarManager {

    private static func getWeekdayWithYear(_ year: Int, _ month: Int, _ day: Int) -> Int {
        var comps = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year

        let calendar = Calendar.current
        let date = calendar.date(from: comps)
        let weekdayComponents = calendar.component(.weekday, from: date!)

        //每周从哪天开始
        var weekDayNum = weekdayComponents - 1
        if weekDayNum == 0 {
            weekDayNum = 7
        }
        return weekDayNum
    }

    private static func currentDayIsHaveRecord(_ year: Int, _ month: Int, _ day: Int) -> Bool {

        let dateStr = year.description + "/" + month.description + "/" + day.description
        var model = HistroyDataFlagModel()
        model.userId = CurrentUserID
        model.btMac = CurrentMacAddress
        model.timeStamp = FDDateHandleTool.dateStringToTimeStamp(stringTime: dateStr, timeForm: "yyyy/MM/dd")

        let exist = try! CurrentDayFlagDataHelper.checkColumnExists(item: model)

        return exist

    }
}
extension Date {

    /// How many days in current month
    var CalendarDays: Int {
        get {
            return Calendar.current.range(of: .day, in: .month, for: self)!.count
        }
    }
    /// How many WeekOfMonths in current month
    var CalendarWeekOfMonths: Int {
        get {
            var calendar = Calendar.current
            //设置每周一是从周几开始的。默认是周日，也就是 firstWeekday = 1.
            calendar.firstWeekday = 2
            return calendar.range(of: .weekOfMonth, in: .month, for: self)!.count
        }
    }
}
