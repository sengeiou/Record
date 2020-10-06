//
//  ChartsCurveExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/20.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

extension MydayChartsView {
    
    func drawCurveCharts(_ color: UIColor) {
        
        drawCurveAbscissaAndYLabels()
        drawCurveXValues()
        drawCurve(color)
        
    }
    
    private func drawCurve(_ color: UIColor) {
        
        var points = [CGPoint]()
        //        var chartViewDotWidth: CGFloat = (chartW - MydayConstant.chartViewYValueWidth) / CGFloat(model.descModel.count * 2)
        
        //固定心率值显示的宽。值多的话。连接起来看起来就是直线了.3.13
        let chartViewDotWidth: CGFloat = 2
        
        for i in 0 ..< model.descModel.count {
            
            let pointValue = model.descModel[i]
            
            
            let yValue = pointValue.points.first!.yValue
            
            if yValue == 0 {
                continue
            }
            
            //心率能表示的最大是FF.这里设置为300足够
            let scalingY = CGFloat( Double(yValue) / Double(300))
            let pillarHeight = scalingY * (chartH)
            
            let pointY = MydayConstant.chartViewValueLabelHeight + MydayConstant.chartViewTriangleWidth + chartH - pillarHeight
            let pointX = MydayConstant.chartViewYValueWidth + (kMargin / 4) + (chartViewDotWidth / 2) + getBloodSugarHRXScale(pointValue)
            let point = CGPoint.init(x: pointX, y: pointY)
            
            let dotOrigin = CGPoint.init(x: pointX - (chartViewDotWidth / 2), y: pointY - (chartViewDotWidth / 2) )
            
            let path = UIBezierPath.init(ovalIn: CGRect.init(origin: dotOrigin, size: CGSize.init(width: chartViewDotWidth, height: chartViewDotWidth)))
            let dotLayer = CAShapeLayer()
            dotLayer.fillColor = color.cgColor
            dotLayer.path = path.cgPath
            contentView.layer.addSublayer(dotLayer)
            
            mydayHeatRateDotItems.append(MydayPillarItem.init(bezierPath: path, shapeLayer: dotLayer, valueStr: yValue.description))
            
            points.append(point)
        }
        
        let curveLayer = CAShapeLayer()
        curveLayer.fillColor = UIColor.clear.cgColor
        curveLayer.lineWidth = 1
        curveLayer.strokeColor = color.cgColor
        
        let curvePath = UIBezierPath.init(points: points)
        curveLayer.path = curvePath.cgPath
        curveLayer.add(getBaseAnimation("strokeEnd"), forKey: "curveLayer.CABasicAnimation")
        contentView.layer.addSublayer(curveLayer)
        
    }
    
    /// 画横轴线和Y轴上的Label
    fileprivate func drawCurveAbscissaAndYLabels () {
        
        //最底部那根横线
        let bottomLineOrigin = CGPoint.init(x: kMargin / 4, y: self.height - XValueLayerHeight)
        let bottomLineSize = CGSize.init(width: chartW , height: 1)
        let bottomLineRect = CGRect.init(origin: bottomLineOrigin, size: bottomLineSize)
        
        let layer = CALayer()
        layer.frame = bottomLineRect
        layer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
        contentView.layer.addSublayer(layer)
        
        let yValues = getHeatRateYvalues()
        
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
    
    private func getHeatRateYvalues() ->[String] {
        var yValues = [String]()
        let step = 300 / 4
        for i in 1 ... 4 {
            yValues.append((step*i).description)
        }
        yValues.reverse()
        return yValues
    }
    private func drawCurveXValues() {
        
        let scaleX = (chartW - 25.auto())  / CGFloat(5)
        
        let textWidth: CGFloat = scaleX , textHeight: CGFloat = 20.auto()
        let dataSource = getBloodSugarHRXValues()
        let pointY = self.height - (textHeight * 1.5)
        
        for i in 0 ..< 5 {
            // + 25的原因是空出左边Yvalue的显示
            let pointX:CGFloat = kMargin / 4 + 25.auto() + scaleX * CGFloat(i)
            
            let textLayerFrame = CGRect.init(x: pointX, y: pointY, width: textWidth, height:textHeight )
            let string = dataSource[i]
            
            let  textLayerString = filterEmptyValue(string)
            let textLayerSize: CGFloat = 15.auto()
            
            contentView.layer.addSublayer(getTextLayer(frame: textLayerFrame, string: textLayerString, size: textLayerSize))
            
        }
    }
    
    func handleCurveEvent(_ point: CGPoint) {
        
        for pillarItem in mydayHeatRateDotItems {
            
            let contain = (pillarItem.path.bounds.minX < point.x) && (pillarItem.path.bounds.maxX > point.x)
            
            if contain {
                //That is in main thread
                let yValue = pillarItem.valueStr
                valueLabel.text = yValue
                pillarItem.layer.fillColor = chartsFillColor.lighterColor.cgColor
                
            }else {
                pillarItem.layer.fillColor = chartsFillColor.cgColor
                
            }
        }
    }
}
