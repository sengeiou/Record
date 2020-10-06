//
//  FDBirthdayPickerView.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class FDBirthdayPickerView: UIView {

    //是不是中国时区
    var isChinaTimeZone : Bool!
    
    var birthDayBlock: ((String) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        //        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 传值进来,格式要对应
    ///
    /// - Parameters:
    ///   - isChinaTimeZone: true   false
    ///   - currentDate:yyyy-MM-dd  MM-dd-yyyy
    func getCurrentTimeZoneAndTime(isChinaTimeZone:Bool,currentDate:String){
        self.isChinaTimeZone = isChinaTimeZone

        //1991-12-31
        //                let array : Array = String(format: "%@",timeString).components(separatedBy: "-")
        //                var birthDayStr = timeString
        //                if FDLanguageChangeTool.shared.currentLanguage != .zhHans {
        //                    birthDayStr = String(format: "%@-%@-%@",array[safe:1] ?? "",array[safe:2] ?? "",array[safe: 0] ?? "")
        //                }

        let birthDayStr = UserInfoManager.coverBirthDayStr(currentDate)
        configUI(currentDate: birthDayStr)

    }
    
    private func configUI(currentDate:String){
        
        let datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width:SCREEN_WIDTH - 40.auto(), height: SCREEN_HEIGHT * 0.38))
        datePicker.datePickerMode = UIDatePicker.Mode.date
        //        datePicker.subviews[0].subviews[1].backgroundColor = UIColor.red
        //        datePicker.subviews[0].subviews[2].backgroundColor = UIColor.yellow


        let formatter = DateFormatter()
        let maxDate = Date()
        var minDate = Date()

        if self.isChinaTimeZone == true {
            datePicker.setDate(self.stringToDate(timeString:currentDate) as Date, animated: true)
            datePicker.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "yyyy-MM-dd"
            minDate = formatter.date(from: "1900-01-01")!
            
        }else{
            datePicker.setDate(self.stringToDate(timeString:currentDate) as Date, animated: true)
            datePicker.locale = Locale(identifier: "en-US")
            formatter.dateFormat = "MM-dd-yyyy"
            minDate = formatter.date(from: "01-01-1900")!
        }
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        datePicker.addTarget(self, action: #selector(dateChanged),for: .valueChanged)

        //隐藏Pickview上的两根横线
        let reduceWidth: CGFloat = 15.auto()
        if let pickerView = datePicker.subviews.first {
            for subview in pickerView.subviews {
                if subview.frame.height <= 5 {

                    subview.isHidden = true
                    let lineView = UIView.init(frame: CGRect.init(x: reduceWidth, y: subview.y, width: subview.width - (reduceWidth * 2), height: subview.height))
                    lineView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
                    pickerView.addSubview(lineView)
                }
            }

        }

        addSubview(datePicker)
    }


    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        if self.isChinaTimeZone == true {
            formatter.dateFormat = "yyyy-MM-dd"
        }else{
            formatter.dateFormat = "MM-dd-yyyy"
        }
        
        if self.birthDayBlock != nil {
            self.birthDayBlock!(formatter.string(from: datePicker.date))
        }
    }
    //时间字符串转NSDate
    func stringToDate(timeString:String)->NSDate{

        //1991-12-31
        //        let array : Array = String(format: "%@",timeString).components(separatedBy: "-")
        //        var birthDayStr = timeString
        //        if FDLanguageChangeTool.shared.currentLanguage != .zhHans {
        //            birthDayStr = String(format: "%@-%@-%@",array[safe:1] ?? "",array[safe:2] ?? "",array[safe: 0] ?? "")
        //        }


        let formatter = DateFormatter()

        if self.isChinaTimeZone == true {
            formatter.dateFormat = "yyyy-MM-dd"
        }else{
            formatter.dateFormat = "MM-dd-yyyy"
        }

        guard let date = formatter.date(from: timeString) else {
            return NSDate()
        }
        let dateStamp:TimeInterval = date.timeIntervalSince1970
        let newDate = NSDate(timeIntervalSince1970: dateStamp)
        return newDate
    }
}
