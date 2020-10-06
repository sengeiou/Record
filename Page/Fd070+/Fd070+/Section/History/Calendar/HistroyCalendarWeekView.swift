//
//  HistroyCalendarWeekView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/19.
//  Copyright © 2019年 WANG DONG. All rights reserved.
//

import UIKit

class HistroyCalendarWeekView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        
        self.backgroundColor = MainColor
        
        let days = ["HistoryVC_calendar_weekMon".localiz(),
                    "HistoryVC_calendar_weekTue".localiz(),
                    "HistoryVC_calendar_weekWed".localiz(),
                    "HistoryVC_calendar_weekThu".localiz(),
                    "HistoryVC_calendar_weekFri".localiz(),
                    "HistoryVC_calendar_weekSat".localiz(),
                    "HistoryVC_calendar_weekSun".localiz()]

        let labelWidth = self.width / 7
        let labelHeight = labelWidth / 2
        
        for i in 0 ..< 7 {
            let labelX = CGFloat(i) * labelWidth
            let label = UILabel.init(frame: CGRect.init(x: labelX, y: 0, width: labelWidth, height: labelHeight))
            label.text = days[i]
            label.font = UIFont.systemFont(ofSize: 17.auto())
            label.textColor = UIColor.white
            label.textAlignment = .center
            addSubview(label)
        }
        
    }
    
}
