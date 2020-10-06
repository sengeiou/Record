//
//  ChartschunkExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/20.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

extension MydayChartsView {
    
    func drawChunkCharts(_ color: UIColor) {

        drawAbscissaAndYLabels()
        drawXValues()
        drawChunk(color)
        
    }

    private func drawChunk(_ color: UIColor) {

        //        let chunkWidth: CGFloat = (chartW - MydayConstant.chartViewYValueWidth) / CGFloat(model.descModel.count * 2)
        //固定了血糖的宽。其实数据多的话，连成的就是线。3.13
        let chunkWidth: CGFloat = 2.auto()

        let bottomY = self.height - kMargin - MydayConstant.chartViewValueLabelHeight
        let topY: CGFloat =  MydayConstant.chartViewTriangleWidth

        let scaleY = (bottomY - topY) / 6

        var positionY = [CGFloat]()
        for i in 0 ... 2 {
            let y = scaleY * CGFloat((i * 2) + 1)
            positionY.append(y)

        }
        positionY.reverse()

        for i in 0 ..< model.descModel.count {

            let pointValue = model.descModel[i]
            
            let yValue = pointValue.points.first?.yValue
            
            if yValue == 0 {
                continue
            }


            let yPoint = kMargin + (1 - yValue! / maxYModel.yValue) * (chartH)
            let xPoint = getBloodSugarHRXScale(pointValue)
            //            let xPoint = (scaleX * CGFloat(i)) + abs((columnWidth - scaleX) / 2)

            let point = CGPoint.init(x: xPoint, y: yPoint)

            var pointY:CGFloat = positionY[2]
            if yValue == 1 {
                pointY = positionY[0]
            }else if yValue == 2 {
                pointY = positionY[1]
            }

            //加了一个固定的X值。以防靠近Y轴太近。3.13
            let pointX = MydayConstant.chartViewYValueWidth + (kMargin / 4) + point.x + 5
            let rect = CGRect.init(x: pointX, y: pointY, width: chunkWidth , height: chunkWidth)

            let chunkLayer = CAShapeLayer()
            chunkLayer.fillColor = color.cgColor

            let path = UIBezierPath.init(ovalIn: rect)
            chunkLayer.path = path.cgPath
            chunkLayer.add(getBaseAnimation("opacity"), forKey: "chunkLayer.CABasicAnimation")

            contentView.layer.addSublayer(chunkLayer)
            mydayBoodSugarChunkItems.append(MydayPillarItem.init(bezierPath: path, shapeLayer: chunkLayer, valueStr: (yValue?.description)!))
        }

        addBloodSugarTestBtn()
    }

    fileprivate func addBloodSugarTestBtn() {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20.auto())
        btn.setTitle("MydayVC_bloodSugarTest".localiz(), for: .normal)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.black, for: .normal)

        contentView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-kMargin/4)
        }
        btn.addTarget(self, action: #selector(self.bloodSugarTestBtnClick), for: .touchUpInside)
    }

    @objc func bloodSugarTestBtnClick() {

        if bloodSugarTestClosure != nil {
            bloodSugarTestClosure!()
        }
    }
    
    func drawAbscissaAndYLabels () {
        
        let originX = kMargin / 4
        
        
        let bottomY = self.height - kMargin - MydayConstant.chartViewValueLabelHeight
        let topY: CGFloat =  MydayConstant.chartViewTriangleWidth
        
        let lineSize = CGSize.init(width: chartW, height: 1)
        
        let YAxissScale = (bottomY - topY) / 6
        
        for i in 0 ... 6 {

            //最下面的线不显示。
            if i == 0 {
                continue
            }
            let originY = bottomY - YAxissScale * CGFloat(i)
            let origin:CGPoint = CGPoint.init(x: originX , y: originY)
            let rect = CGRect.init(origin: origin, size: lineSize)
            
            let layer = CAShapeLayer()
            layer.frame = rect
            drawDashLine(shapeLayer: layer, lineLength: 2, lineSpacing: 3, lineColor: UIColor.white)
            

        }
        
        let colors = [UIColor.blue, UIColor.green, UIColor.red]
        let strings = ["MydayVC_bloodSugarValue_low".localiz(),
                       "MydayVC_bloodSugarValue_normal".localiz(),
                       "MydayVC_bloodSugarValue_high".localiz()]

        for i in 0 ... 2 {
            
            let width: CGFloat = MydayConstant.chartViewYValueWidth
            let height = YAxissScale * 2
            let x = originX
            let y = bottomY - height * CGFloat(i + 1)
            
            let layer = CALayer()
            layer.frame = CGRect.init(x: x, y: y, width: width, height: height)
            layer.backgroundColor = colors[i].cgColor.copy(alpha: 0.5)
            
            let textWidth = width
            
            let textLayerFrame = CGRect.init(x: 0, y: (layer.height - textWidth ) / 2, width: textWidth, height: textWidth)
            let textLayerString = strings[i]
            let textLayerSize: CGFloat = 15.auto()
            
            layer.addSublayer(getTextLayer(frame: textLayerFrame, string: textLayerString, size: textLayerSize))
            
            
            contentView.layer.addSublayer(layer)
        }


        let layer = CALayer()
        layer.frame = CGRect.init(origin: CGPoint.init(x: originX, y: bottomY), size: lineSize)
        layer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
        contentView.layer.addSublayer(layer)

        
    }

    private func drawXValues() {

        let scaleX = (chartW - MydayConstant.chartViewYValueWidth)  / CGFloat(5)
        let pointY = self.height - kMargin - MydayConstant.chartViewValueLabelHeight

        let textWidth: CGFloat = scaleX, textHeight: CGFloat = 15.auto()
        let dataSource = getBloodSugarHRXValues()

        for i in 0 ..< 5 {
            let pointX:CGFloat = kMargin / 4 + MydayConstant.chartViewYValueWidth + scaleX * CGFloat(i)
            let point = CGPoint.init(x: pointX, y: pointY)

            let textLayerFrame = CGRect.init(x: point.x, y: point.y + 5.auto(), width: textWidth, height:textHeight )
            
            let textLayerSize: CGFloat = 10.auto()
            let string = dataSource[i]
            contentView.layer.addSublayer(getTextLayer(frame: textLayerFrame, string: string, size: textLayerSize))

        }
    }

    func handleChunkEvent(_ point: CGPoint) {
        
        for pillarItem in mydayBoodSugarChunkItems {

            let contain = (pillarItem.path.bounds.minX < point.x) && (pillarItem.path.bounds.maxX > point.x)

            if contain {
                //That is in main thread
                let yValue = pillarItem.valueStr
                //数值暂不处理显示
                pillarItem.layer.fillColor = chartsFillColor.lighterColor.cgColor

            }else {
                pillarItem.layer.fillColor = chartsFillColor.cgColor

            }
        }

    }
    
}
