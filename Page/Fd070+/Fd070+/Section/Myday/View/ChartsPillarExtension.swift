//
//  ChartsPillarExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/20.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

extension MydayChartsView {
    
    func drawPillarCharts(_ color: UIColor) {
        
        drawPillarbAscissaAndYLabels()
        drawPillarXValues()
        drawPillar(color)
        
    }

    private func drawPillar(_ color: UIColor) {

        //数据是以2小时为一组汇总的
        let scaleX = (chartW - MydayConstant.chartViewYValueWidth)  / CGFloat(12)

        var maxYValue: CGFloat = 0
        switch model.type {
        case .goal:
            //目标的固定值可写固定100
            maxYValue = 100
            //        case .sleepTime, .sportTime:
            //            //持续时间单位是分钟。是以120分钟（2小时为系数）
        //            maxYValue = 120
        default:

            var maxYValueStr = getSportYValues().first ?? "100"
//            if maxYValueStr.contains("K") {
//                maxYValueStr = String(maxYValueStr.dropLast())
//                maxYValueStr.insert(contentsOf: "000", at: maxYValueStr.endIndex)
//            }

            maxYValue = maxYValueStr.toCGFloat()
        }


        let pillarWidth = scaleX / 2
        for i in 0 ..< model.descModel.count {

            let descModel = model.descModel[i]

            let xValue = descModel.xValue
            let yValue = descModel.points.first!.yValue

            if yValue == 0 {
                continue
            }
            
            let scalingY = CGFloat( (yValue) / (maxYValue))
            let pillarHeight = (scalingY * (chartH))

            let pointY = self.height - (XValueLayerHeight) - pillarHeight
//             let pointY = chartH - pillarHeight
            let xIndex = xValue.toCGFloat()
            let pointX = (kMargin / 4) + MydayConstant.chartViewYValueWidth + (pillarWidth / 2) + (scaleX * xIndex)

            let rect = CGRect.init(x: pointX, y: pointY, width: pillarWidth, height: pillarHeight)

            let pillarPath = UIBezierPath.init(rect: rect)

            let pillarLayer = CAShapeLayer()
            pillarLayer.path = pillarPath.cgPath
            pillarLayer.fillColor = color.cgColor

            contentView.layer.addSublayer(pillarLayer)
            mydaySportPillarItems.append(MydayPillarItem.init(bezierPath: pillarPath, shapeLayer: pillarLayer, valueStr: yValue.description))
        }
    }
    
    
    /// 画横轴线和Y轴上的Label
    private func drawPillarbAscissaAndYLabels () {
        
        //最底部那根横线
        let bottomLineOrigin = CGPoint.init(x: kMargin / 4, y: self.height - XValueLayerHeight)
        let bottomLineSize = CGSize.init(width: chartW , height: 1)
        let bottomLineRect = CGRect.init(origin: bottomLineOrigin, size: bottomLineSize)
        
        let layer = CALayer()
        layer.frame = bottomLineRect
        layer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
        contentView.layer.addSublayer(layer)

        let yValues = getSportYValues()

        //顶部设置的空余高度
        let topRestHeight = MydayConstant.chartViewTriangleWidth + MydayConstant.chartViewValueLabelHeight + (kMargin / 4)
        let YAxissScale = (bottomLineOrigin.y - topRestHeight) / CGFloat(4)
        for i in 0 ..< 4 {

            //这是自上而下画的
            let origin:CGPoint = CGPoint.init(x: kMargin / 4 , y: topRestHeight + YAxissScale * CGFloat(i))
            let size = CGSize.init(width: chartW, height: 1)
            let rect = CGRect.init(origin: origin, size: size)
            
            let layer = CAShapeLayer()
            layer.frame = rect
            layer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
            //            drawDashLine(shapeLayer: layer, lineLength: 2, lineSpacing: 3, lineColor: UIColor.white)
            contentView.layer.addSublayer(layer)

            let textLayerFrame = CGRect.init(x: origin.x, y: origin.y, width: MydayConstant.chartViewYValueWidth, height: MydayConstant.chartViewYValueHeight)
            let textLayerString = yValues[safe: i] ?? ""
            let textLayerSize: CGFloat = 15.auto()
            
            let textLayer = getTextLayer(frame: textLayerFrame, string: textLayerString, size: textLayerSize)

            textLayer.alignmentMode = kCAAlignmentLeft
            contentView.layer.addSublayer(textLayer)
        }
        
    }

    private func getSportYValues() ->[String] {

        var yValues = [String]()

        switch model.type {
        case .goal:
            yValues = ["100",
                       "70",
                       "50",
                       "25",
                       "0"]
            //        case .sleepTime, .sportTime:
            //
            //            //持续时间单位是分钟。是以60分钟（1小时为系数）
            //            let maxYvalue = (Int(maxYModel.yValue / 60) + 1) * 60
            //            let step = maxYvalue / 4
            //            for i in 0 ..< 5 {
            //                yValues.append((i * step ).description)
            //            }
        //            yValues.reverse()
        default:

            let ratio = getSportRatio()

            let step  =  ((Int(maxYModel.yValue) / 4 / Int(ratio)) + 1) * Int(ratio)
            for i in 0 ..< 5 {


                let yValue = i * step
                var yValueStr = yValue.description
                //大于1000的话就以K为单位
//                if yValue > 1000 {
//                    yValueStr = (yValue / 1000).description + "K"
//                }
                yValues.append(yValueStr)
            }
            yValues.reverse()
        }


        return yValues

    }


    private func getSportRatio() ->CGFloat {

        switch maxYModel.yValue {
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
    
    private func drawPillarXValues() {
        
        let dataSource = ["00:00", "06:00", "12:00", "18:00", "00:00"]
        
        let scaleX = (chartW - 25.auto()) / CGFloat(dataSource.count)

        let textWidth: CGFloat = scaleX , textHeight: CGFloat = 20.auto()
        let pointY = self.height - (textHeight * 1.5)
        
        for i in 0 ..< dataSource.count {
            // + 25的原因是空出左边Yvalue的显示
            let pointX:CGFloat = kMargin / 4 + 25.auto() + scaleX * CGFloat(i)
            let point = CGPoint.init(x: pointX, y: pointY)

            let textLayerFrame = CGRect.init(x: point.x, y: point.y , width: textWidth, height:textHeight )
            let textLayerSize: CGFloat = 15.auto()
            let string = dataSource[i]

            let textLayer = getTextLayer(frame: textLayerFrame, string: string, size: textLayerSize)

            contentView.layer.addSublayer(textLayer)
            
        }
    }
    
    func handlePillerEvent(_ point: CGPoint) {

        for pillarItem in mydaySportPillarItems {

            let contain = (pillarItem.path.bounds.minX < point.x) && (pillarItem.path.bounds.maxX > point.x)

            if contain {
                //That is in main thread
                let yValue = pillarItem.valueStr
                
                switch model.type {
                //步数不应有小数点, 后面加个空格，防止字符串被切割
                case .walk:
                    if yValue.contains(".") {
                        valueLabel.text = String(yValue.dropLast().dropLast()) + " "
                    }
                case .calorie:
                    valueLabel.text = MydayManager.coverCalorieValue(calorie: yValue).0 + " "
                case .distance:
                    valueLabel.text = MydayManager.coverDistanceValue(distance: yValue).0 + " "
                //时间要富文本显示
                case .sportTime, .sleepTime:
                    let duration = MydayManager.setTimeDuration(yValue)
                    valueLabel.attributedText = MydayManager.highlightDurationUnitWords(duration)

                default:
                    valueLabel.text = yValue + " "
                }
                pillarItem.layer.fillColor = chartsFillColor.lighterColor.cgColor
                continue
            }else {
                pillarItem.layer.fillColor = chartsFillColor.cgColor

            }
        }
        
    }

}

/// 柱子的结构体。用来保存柱子的Layer和Path.在触摸事件用要用到
struct MydayPillarItem {

    var path = UIBezierPath()
    var layer = CAShapeLayer()
    var valueStr = ""

    init(bezierPath: UIBezierPath, shapeLayer: CAShapeLayer, valueStr: String) {
        self.path = bezierPath
        self.layer = shapeLayer
        self.valueStr = valueStr
    }
}
