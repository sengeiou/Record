//
//  FDSleepDetailModel.swift
//  FD070+
//
//  Created by WANG DONG on 2019/2/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

/********************************睡眠日详情相关的Model***************************************/

/// 从数据库经过一级处理的原始数据
struct FDSleepDetailOriginalModel {
    var date = "" //具体的日期
    var sleepTotalCount:Int = 0  //睡眠总时长
    var sleepStart:Double = 0 //睡眠的开始时间
    var sleepEnd:Double = 0    //睡眠的结束时间
    var sleepDeepCount:Int = 0  //深睡时长
    var sleepLightCount:Int = 0    //浅睡时长
    var sleepSoberCount:Int = 0  //清醒时长
    var sleepDetailArray = [sleepOriginalModel]() //睡眠详情数组
}


/// 数据库取出的原始数据
struct sleepOriginalModel {
    var sleepType:FDSleepType?
    var sleepDate:Double?
}

/// 每一小段的睡眠模型
struct FDSleepDetailModel {

    var sleepType:FDSleepType?  //睡眠的类型，1：深睡；2.浅睡；3：清醒
    var sleepStartTime:Double = 0 //睡眠的开始时间
    var sleepEndTime:Double = 0    //睡眠的结束时间
    var sleepStartX:CGFloat = 0  //每段的开始坐标 ,画图之前为0
    var sleepEndX:CGFloat = 0    //每段的结束坐标，画图之前为0
    var sleepLayer:CALayer = CALayer()  //每段显示的Layer、画图之前为Nil
    var originalColor:CGColor = UIColor.clear.cgColor //每段layer原始的颜色、画图之前为空
    
}


/// 处理成汇总数据之后的Model
struct FDSleepDetailSummaryModel {
    
    var date = ""
    var valueTotal = ""
    var unit = ""
    var sleepTotalCount:Int = 0  //睡眠总时长
    var sleepStart:Double = 0 //睡眠的开始时间
    var sleepEnd:Double = 0    //睡眠的结束时间
    var sleepDeepCount:Int = 0  //深睡时长
    var sleepLightCount:Int = 0    //浅睡时长
    var sleepSoberCount:Int = 0  //清醒时长
    var summaryType = HistorySportSummaryType.day
    var values = [FDSleepDetailModel]()
}
/********************************睡眠月和年详情相关的Model***************************************/

struct FDSleepMonthSummaryModel {
    var month = ""   //月份
    var sleepDeepTotal:Int = 0 //这个月的总深睡时长
    var sleepLightTotal:Int = 0 //这个月的总浅睡时长
    var sleepsoberTotal:Int = 0 //这个月的总清醒时长
    var sleepTotalMax:Int = 0  //这个月睡眠的最大值
    
    var sleepValues  = [FDSleepDayDetailModel]()    //每天睡眠的详情数据Model
    
}


struct FDSleepDayDetailModel {
    var date = ""  //日期中的”日“数据
    var sleepDeepTotal:Int = 0 //这一天的总深睡时长
    var sleepLightTotal:Int = 0 //这一天的总浅睡时长
    var sleepsoberTotal:Int = 0 //这一天的总清醒时长
    
    var sleepStartTime:Double = 0 //睡眠的开始时间
    var sleepEndTime:Double = 0 //睡眠的结束时间
    
    var sleepLayer:CALayer?  //UI显示时对应的Layer
    
    var sleepViewData:FDSleepDiffColorLayer? //每个layer对应的数据
    
}


struct FDSleepDiffColorLayer {
    var deepProportion:Double = 0 //深睡占最大睡眠值的比例
    var lightProportion:Double = 0 //浅睡占最大睡眠值的比例
    var soberProportion:Double = 0 // 清醒占最大睡眠的比例
    
    var deepColor:UIColor?  //深睡的颜色
    var lightColor:UIColor? //浅睡的颜色
    var soberColor:UIColor? //清醒的颜色
    
}

