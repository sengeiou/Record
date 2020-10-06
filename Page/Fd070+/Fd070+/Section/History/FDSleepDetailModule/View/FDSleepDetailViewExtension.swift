//
//  FDSleepDetailViewExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2019/4/29.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Public func
extension FDSleepDetailView {

    func getTextLayer(frame: CGRect, string: String, size: CGFloat) ->CATextLayer {

        let textLayer = FDVerticalCenterTextLayer()
        textLayer.frame = frame
        textLayer.position = CGPoint.init(x: frame.midX, y: frame.midY)
        textLayer.contentsScale = UIScreen.main.scale

        let font = UIFont.systemFont(ofSize: size)
        textLayer.font = CGFont.init(font.fontName as CFString)
        textLayer.fontSize = font.pointSize
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.string = string
//                                textLayer.backgroundColor = UIColor.randomColor.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.white.cgColor

        return textLayer
    }
}
// MARK: - Draw public Layer
extension FDSleepDetailView {

     func drawIndicator() {

        let layerTopY: CGFloat = descViewHeigth
        let layerBottomY: CGFloat = viewHeight - sliderViewHeight - labelHeight
        indicatorLayer.frame = CGRect(x: 0, y: layerTopY, width: 0.5, height: layerBottomY - layerTopY)
        indicatorLayer.isHidden = true
        indicatorLayer.backgroundColor = UIColor.white.cgColor
        self.layer.addSublayer(indicatorLayer)
    }
     func drawSleepAbscissa() {

        let layerTopY: CGFloat = descViewHeigth
        let layerBottomY: CGFloat = viewHeight - sliderViewHeight - labelHeight
        let layerX: CGFloat = 10
        let layerWidth = self.width - 20
        let layerHeight: CGFloat = 0.5
        let layerScale = (layerBottomY - layerTopY) / CGFloat(3)

        var dataSouce = [String]()
        if sleepSummaryType != .day {
            dataSouce =  getSleepDurationYValues()

        }

        //默认3根横坐标
        for i in 0 ... 3 {

            //这个是从上往下画的
            let lineLayer = CALayer()
            let layerY = layerTopY + CGFloat(i) * layerScale

            let layerRect = CGRect.init(x: layerX, y: layerY, width: layerWidth, height: layerHeight)
            lineLayer.frame = layerRect
            lineLayer.backgroundColor = UIColor.RGB(r: 110, g: 172, b: 255).cgColor
            self.layer.addSublayer(lineLayer)

            if !dataSouce.isEmpty {
                let sleepStateTextLayer = getTextLayer(frame: CGRect.init(x: layerRect.maxX - 30 , y: layerRect.maxY - 13, width: 30, height: 10), string: dataSouce[i], size: 10.auto())
                sleepStateTextLayer.alignmentMode = kCAAlignmentRight
                self.layer.addSublayer(sleepStateTextLayer)
            }
        }

    }

     func getSleepDurationYValues() ->[String] {

        let step = Int(sleepDurationMax) / 3
        var textDataSource = [String]()
        for i in 1 ... 3 {
            let yValue = (i * step)
            textDataSource.append(getSleepDurationString(yValue))
        }
        textDataSource.insert("", at: 0)
        textDataSource.reverse()

        return textDataSource

    }


    func getSleepDurationString(_ minuteInt: Int) ->String {

        var minute = (minuteInt % 60).description
        var hour = (minuteInt / 60).description


        if minute.count < 2 {
            minute.insert("0", at: minute.startIndex)
        }

        if hour.count < 2 {
            hour.insert("0", at: hour.startIndex)
        }

        return hour + ":" + minute
    }


     func getSleepRatio(_ maxValue: Int) ->CGFloat {

        switch maxValue {
        case 0 ..< 100:
            return 1

        case 100 ..< 1000:
            return 10

        case 1000 ..< 10000:
            return 100

        case 10000 ..< 100000:
            return 1000

        case 100000 ..< 1000000:
            return 10000

        default:
            return 100000
        }
    }

     func addChartDescriptionView() {

        let chartDescriptionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: descViewHeigth / 2))
        //        chartDescriptionView.backgroundColor = UIColor.randomColor
        chartDescriptionView.backgroundColor = UIColor.clear
        addSubview(chartDescriptionView)

        chartDescriptionView.addSubview(dateLabel)

        if isShowSliderView == false {
            //不显示日期.在MyDay图表中类型中使用
            dateLabel.isHidden = true
            dateLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.snp.top)
            }
        }else {
            dateLabel.snp.makeConstraints { (make) in
                make.centerX.top.equalToSuperview()
            }
        }



        chartDescriptionView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

    }

     func addsleepStateIndicatorLayer() {

        //睡眠汇总要显示的Layer
        sleepStateIndicatorLayer.frame = CGRect.init(x: 0, y: descViewHeigth / 2, width: self.width, height: descViewHeigth / 2)
        //        sleepStateIndicatorLayer.backgroundColor = UIColor.randomColor.cgColor
        sleepStateIndicatorLayer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(sleepStateIndicatorLayer)

        addSleepSummaryLayer()

    }

    private func addSleepSummaryLayer() {

        let leftMargin = SCREEN_WIDTH * 0.107
        let centMargin = SCREEN_WIDTH * 0.131

        let sleepStateLayerWidth = (SCREEN_WIDTH - (centMargin * 2) - (leftMargin * 2)) / 3
        let sleepSummaryLayerHeigh: CGFloat = descViewHeigth / 2
        //深眠时长、浅睡总时长、清醒总时长
        var deepSleepDuration, lightSleepDuration, awakeDutaion: String

        switch self.sleepSummaryType! {
        case .day:
            deepSleepDuration = FDSleepDetailManager.getSleepDuration(sleepDetailModel.sleepDeepCount)
            lightSleepDuration = FDSleepDetailManager.getSleepDuration(sleepDetailModel.sleepLightCount)
            awakeDutaion = FDSleepDetailManager.getSleepDuration(sleepDetailModel.sleepSoberCount)

        case .month, .year:
            deepSleepDuration = FDSleepDetailManager.getSleepDuration(sleepMonthModel.sleepDeepTotal)
            lightSleepDuration = FDSleepDetailManager.getSleepDuration(sleepMonthModel.sleepLightTotal)
            awakeDutaion = FDSleepDetailManager.getSleepDuration(sleepMonthModel.sleepsoberTotal)

        }

        //显示睡眠状态的元组 (睡眠状态描述， 显示状态的颜色， 睡眠状态的时长)
        let awakeSleepTuple = ("HistoryVC_awake".localiz(), sleepViewColor![0], awakeDutaion)
        let lightSleepTuple = ("HistoryVC_lightSleep".localiz(), sleepViewColor![1], lightSleepDuration)
        let deepSleepTuple = ("HistoryVC_deepSleep".localiz(), sleepViewColor![2], deepSleepDuration)

        var sleepStateTuple = [(String, UIColor, String)]()
        sleepStateTuple.append(awakeSleepTuple)
        sleepStateTuple.append(lightSleepTuple)
        sleepStateTuple.append(deepSleepTuple)

        //循环创建睡眠状态子Layer
        for i in 0 ... 2 {
            let x = leftMargin + CGFloat(i) * (sleepStateLayerWidth + centMargin)
            let sleepStateLayerRect = CGRect.init(x: x, y: 0, width: sleepStateLayerWidth, height: sleepSummaryLayerHeigh)
            sleepStateIndicatorLayer.addSublayer(getSleepStateLayer(sleepStateLayerRect, sleepStateTuple[i], i))
        }

    }


     func getSleepStateLayer(_ rect: CGRect, _ sleepStateTuple: (String, UIColor, String), _ index: Int) -> CALayer {

        let sleepStateIndicatorLayerHeight: CGFloat = 4
        let sleepTimeTextLayerSize: CGFloat = 15.auto()

        let sleepStateLayer = CALayer()

        sleepStateLayer.frame = rect

        let sleepStateIndicatorLayer = CAShapeLayer()
        let bezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: (rect.height - sleepStateIndicatorLayerHeight) / 2, width: rect.width, height: sleepStateIndicatorLayerHeight), byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: sleepStateIndicatorLayerHeight, height: sleepStateIndicatorLayerHeight))
        sleepStateIndicatorLayer.path = bezierPath.cgPath
        sleepStateIndicatorLayer.fillColor = sleepStateTuple.1.cgColor

        sleepStateLayer.addSublayer(sleepStateIndicatorLayer)

        let sleepStateTextLayer = getTextLayer(frame: CGRect.init(x: 0, y: 0, width: rect.width, height: (rect.height - sleepStateIndicatorLayerHeight) / 2), string: sleepStateTuple.0, size: sleepTimeTextLayerSize)

        sleepStateLayer.addSublayer(sleepStateTextLayer)

        let sleepTimeTextLayer = getTextLayer(frame: CGRect.init(x: 0, y: bezierPath.bounds.maxY, width: rect.width, height: (rect.height - sleepStateIndicatorLayerHeight) / 2), string: sleepStateTuple.2, size: sleepTimeTextLayerSize)
        sleepTimeTextLayer.name = "sleepDurationText:\(index)"
        sleepStateLayer.addSublayer(sleepTimeTextLayer)

        if index == 0 {
            soberStateTextLayer = sleepTimeTextLayer
        }else if index == 1 {
            lightSleepStateTextLayer = sleepTimeTextLayer
        }else {
            deepSleepStateTextLayer = sleepTimeTextLayer
        }

        return sleepStateLayer

    }
}
// MARK: - Month、Year data
extension FDSleepDetailView {
    func displaySleepMonthView() {

        if self.sleepMonthModel.sleepsoberTotal+self.sleepMonthModel.sleepLightTotal+sleepMonthModel.sleepDeepTotal > 0 {

            //左右让出10，还让出最右边Label的宽30，间隔的宽度为layer的一半。月为单位时， 最多有31天
            let layerWidth = ((SCREEN_WIDTH-20-30) / CGFloat((Double(31) + ceil(Double(31/2)))))
            let awakeBasicY = viewHeight-sliderViewHeight-labelHeight - descViewHeigth

            for i in 0 ..< self.sleepMonthModel.sleepValues.count {

                var model:FDSleepDayDetailModel = self.sleepMonthModel.sleepValues[i]
                let day = model.date.toCGFloat()

                let scal = CGFloat(model.sleepLightTotal + model.sleepDeepTotal + model.sleepsoberTotal) / sleepDurationMax

                let layerFrame = CGRect(x: 10+CGFloat(CGFloat(day)*(1.5 * layerWidth)), y: awakeBasicY * (1 - scal) + descViewHeigth , width: layerWidth, height: awakeBasicY * scal)

                let sleepLayer = creatDiffColorLayer(fram: layerFrame, layerModel: model.sleepViewData!)
                //画图完成之后，更新Model
                model.sleepLayer = sleepLayer
                self.sleepMonthModel.sleepValues[i] = model
                self.layer.addSublayer(sleepLayer)
            }
        }

    }

    func displaySleepYearView() {

        if self.sleepMonthModel.sleepsoberTotal+self.sleepMonthModel.sleepLightTotal+sleepMonthModel.sleepDeepTotal > 0 {

            //左右让出10，还让出最右边Label的宽30，间隔的宽度为layer的一半. 年为单位时，最多有12个月
            let layerWidth = ((SCREEN_WIDTH-20-30) / CGFloat((Double(12) + ceil(Double(6)))))
            let awakeBasicY = viewHeight-sliderViewHeight-labelHeight - descViewHeigth

            for i in 0 ..< self.sleepMonthModel.sleepValues.count {
                //timeLabelArray
                var model:FDSleepDayDetailModel = self.sleepMonthModel.sleepValues[i]
                let day = Int(model.date) ?? 1
                let monthLabelCentX = timeLabelArray[day - 1].centerX
                let scal = CGFloat(model.sleepLightTotal + model.sleepDeepTotal + model.sleepsoberTotal) / sleepDurationMax

                let layerFrame = CGRect(x: monthLabelCentX - (layerWidth / 2), y: awakeBasicY * (1 - scal) + descViewHeigth, width: layerWidth, height: awakeBasicY * scal)
                let sleepLayer = creatDiffColorLayer(fram:layerFrame , layerModel: model.sleepViewData!)
                //画图完成之后，更新Model
                model.sleepLayer = sleepLayer
                self.sleepMonthModel.sleepValues[i] = model
                self.layer.addSublayer(sleepLayer)
            }
        }

    }


    func creatDiffColorLayer(fram:CGRect,layerModel:FDSleepDiffColorLayer) -> CALayer {


        let basicAnimation = CABasicAnimation()
        basicAnimation.keyPath = "transform.scale.y"

        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false

        let layerHeight = fram.height*CGFloat(layerModel.deepProportion + layerModel.lightProportion + layerModel.soberProportion)
        let layerMinY = fram.minY + fram.height * CGFloat(1 - layerModel.deepProportion - layerModel.lightProportion - layerModel.soberProportion)

        let layerOne:CALayer = CALayer.init()
        layerOne.frame = CGRect(x: 0, y: 0, width: fram.width, height: fram.height*CGFloat(layerModel.soberProportion))
        layerOne.backgroundColor = self.sleepViewColor![0].cgColor


        let layerTwo:CALayer = CALayer.init()
        layerTwo.frame = CGRect(x: 0, y: layerOne.frame.maxY, width: fram.width, height: fram.height*CGFloat(layerModel.lightProportion))
        layerTwo.backgroundColor = self.sleepViewColor![1].cgColor

        let layerThree:CALayer = CALayer.init()
        layerThree.frame = CGRect(x: 0, y: layerTwo.frame.maxY, width: fram.width, height: fram.height*CGFloat(layerModel.deepProportion))
        layerThree.backgroundColor = self.sleepViewColor![2].cgColor

        let bgLayer:CALayer = CALayer.init()
        //由于锚点的调整需要调整bglayer的center
        bgLayer.frame = CGRect(x: fram.origin.x, y: layerMinY+layerHeight/2, width: fram.width, height: layerHeight)
        bgLayer.backgroundColor = UIColor.clear.cgColor


        bgLayer.addSublayer(layerOne)
        bgLayer.addSublayer(layerTwo)
        bgLayer.addSublayer(layerThree)

        bgLayer.add(basicAnimation, forKey: "diffColorLayer")
        bgLayer.anchorPoint = CGPoint(x:0.5, y: 1.0)
        return bgLayer
    }
}
