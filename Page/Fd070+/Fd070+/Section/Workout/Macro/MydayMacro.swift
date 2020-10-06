//
//  MydayMacro.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

struct MydayConstant {

    static var currentHours = 10
    static let headViewHeight = 30.auto()
    static let collectionCellSpace:CGFloat  = 5.auto()
    static let collectionCellWidth = (SCREEN_WIDTH / 2) - CGFloat(collectionCellSpace * 2)
    static let circleWith: CGFloat = collectionCellWidth / 2 - 20.auto()
    static let circleSpace: CGFloat = 10.0.auto()
    static let collectionViewCellReuseIdentifier = "MydayViewController.MydayCollectionViewCell"

    static let chartViewHeight: CGFloat = (collectionCellWidth * 1.5).auto()
    static var chartViewValueLabelHeight: CGFloat = 35.auto()
    static let chartViewTriangleWidth: CGFloat = 10.auto()

    static let chartViewYValueWidth: CGFloat = 45.auto()
    static let chartViewYValueHeight: CGFloat = 30.auto()
    static let chartViewYValueFontSize: CGFloat = 15.auto()
    

    static let chartBackgroundColor = UIColor.RGB(r: 3, g: 45, b: 114)

    static let walkFillColor = UIColor.RGB(r: 76, g: 199, b: 188)
    static let percentFillColor = UIColor.RGB(r: 242, g: 103, b: 163)
    static let distanceFillColor = UIColor.RGB(r: 14, g: 122, b: 255)
    static let bloodSugarFillColor = UIColor.RGB(r: 250, g: 0, b: 80)
    static let heartRateFillColor = UIColor.RGB(r: 110, g: 61, b: 187)
    static let sportTimeFillColor = UIColor.RGB(r: 45, g: 68, b: 163)
    static let calorieFillColor = UIColor.RGB(r: 254, g: 215, b: 49)
    static let sleepTimeFillColor = UIColor.RGB(r: 23, g: 155, b: 157)
    static let sleepEfficiencyFillColor = UIColor.RGB(r: 25, g: 147, b: 252)

    //图表内容柱子显示的颜色
    static let walkChartFillColor = UIColor.RGB(r: 0, g: 211, b: 198)
    static let calorieChartFillColor = UIColor.RGB(r: 255, g: 218, b: 0)
    static let sportTimeChartFillColor = UIColor.RGB(r: 104, g: 129, b: 255)
    static let distanceChartFillColor = UIColor.RGB(r: 85, g: 180, b: 253)

    static let progressLineWidth: CGFloat  = 15.auto()

    static let normalNoValuePlace = "0"
    static let bloodSugarNoValuePlace = "---"

    static let heatRateAnimationKey = "heatRateAnimation.transform.scale"

}
