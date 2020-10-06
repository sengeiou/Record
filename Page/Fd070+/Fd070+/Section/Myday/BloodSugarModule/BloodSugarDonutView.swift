//
//  BoodSugarDonutView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/18.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class BloodSugarDonutView: UIView {
    
    private struct Constant {
        static let indicatorLayerWidth: CGFloat = 5
        static let lineWidth: CGFloat = 16.auto()
    }
    var donutView: FDDonutView!
    var indicatorLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {

        //        self.backgroundColor = UIColor.randomColor
        donutView = FDDonutView()
        donutView.frame = self.bounds
        donutView.baseColour = UIColor.white
        donutView.fromColour = UIColor.yellow
        donutView.toColour = UIColor.blue
        donutView.duration = 0
        donutView.lineWidth = Constant.lineWidth
        donutView.layout()
        donutView.set(percentage: 1)
        addSubview(donutView)
        
        
        //        let x = (self.bounds.width - Constant.indicatorLayerWidth) / 2
        //        let y = Constant.indicatorLayerWidth + (Constant.lineWidth / 2)

        //改变了原始坐标点
        let x = self.bounds.width - (Constant.indicatorLayerWidth * 5)
        let y = (self.bounds.height - Constant.indicatorLayerWidth) / 2

        indicatorLayer = CAShapeLayer()
        let path = UIBezierPath.init(ovalIn: CGRect.init(x: x , y: y, width: Constant.indicatorLayerWidth, height: Constant.indicatorLayerWidth))
        indicatorLayer.path = path.cgPath
        indicatorLayer.fillColor = UIColor.RGB(r: 19, g: 50, b: 231).cgColor
        layer.insertSublayer(indicatorLayer, at: 0)
        
    }


    func addIndicatorLayerAnimation() {
        
        removeIndicatorLayerAnimation()
        
        let width = (self.width * 3) / 4
        let x = (self.width - width) / 2
        let y = (self.height - width) / 2
        let rect = CGRect.init(x: x, y: y, width: width, height: width)
        
        let circlePath = UIBezierPath.init(ovalIn: rect)

        //                        let shapeLayer = CAShapeLayer()
        //                        shapeLayer.fillColor = UIColor.randomColor.cgColor
        //                shapeLayer.strokeColor = UIColor.randomColor.cgColor
        //                        shapeLayer.path = circlePath.cgPath
        //                        layer.addSublayer(shapeLayer)

        //FIXME: 这个半径设置大了
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        keyFrame.repeatCount = Float.infinity
        keyFrame.path = circlePath.cgPath
        keyFrame.calculationMode = kCAAnimationCubicPaced
        keyFrame.rotationMode = "auto"
        keyFrame.duration = 2

        indicatorLayer.add(keyFrame, forKey: "bloodGlucoseMeasurementIndicatorLayer.circleAnimation")
        
    }
    
    func removeIndicatorLayerAnimation() {
        indicatorLayer.removeAnimation(forKey: "bloodGlucoseMeasurementIndicatorLayer.circleAnimation")
    }
    
}
