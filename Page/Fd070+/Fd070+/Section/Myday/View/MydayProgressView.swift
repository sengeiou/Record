//
//  MydayProgressView.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class MydayProgressView: UIView {
    
    fileprivate var progressLayer:CAShapeLayer!

    fileprivate var mainColor = UIColor()

    var model: MydayModel = MydayModel() {
        didSet {
            setModelUI()
        }
    }
    var progress: CGFloat = 0 {
        didSet {
            setProgressUI()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate  func setModelUI() {

        if model.type == .bloodSugar {
            return
        }
        setColors(model)

        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }

        insertBackgroundLayer(nil)

        // MARK: - ProgressLayer
        progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        let arcCenter = CGPoint.init(x: self.bounds.height / 2, y: self.bounds.height / 2)
        let radius = MydayConstant.circleWith - MydayConstant.circleSpace
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
            CGFloat(radius), startAngle: CGFloat(rad(value: -90)) , endAngle: CGFloat(rad(value: 270)), clockwise: true)
        progressLayer.path = circlePath.cgPath
        progressLayer.lineWidth    = MydayConstant.progressLineWidth
        progressLayer.lineCap      = kCALineCapRound
        progressLayer.lineJoin     = kCALineCapRound
        progressLayer.strokeColor  = mainColor.cgColor
        progressLayer.fillColor    = UIColor.clear.cgColor
        progressLayer.strokeStart = 0

        var progress = model.progress 
        if progress < 0.001 {
            progress = 0.001
        }
        progressLayer.strokeEnd = progress

        self.layer.addSublayer(progressLayer)
    }

    fileprivate func setProgressUI() {

        setColors(nil)

        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
         let radius = self.bounds.width / 2
        insertBackgroundLayer(radius)

        // MARK: - ProgressLayer
        progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        let arcCenter = CGPoint.init(x: self.bounds.height / 2, y: self.bounds.height / 2)

        let circlePath : UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
            CGFloat(radius), startAngle: CGFloat(rad(value: 0)) , endAngle: CGFloat(rad(value: 360)), clockwise: true)
        progressLayer.path = circlePath.cgPath
        progressLayer.lineWidth    = 5
        progressLayer.lineCap      = kCALineCapRound
        progressLayer.lineJoin     = kCALineCapRound
        progressLayer.strokeColor  = mainColor.cgColor
        progressLayer.fillColor    = UIColor.clear.cgColor
        progressLayer.strokeStart = 0

        if progress < 0.001 {
            progress = 0.001
        }
        progressLayer.strokeEnd = progress

        self.layer.addSublayer(progressLayer)
    }

    fileprivate func insertBackgroundLayer(_ fixedWidth: CGFloat?) {
        // MARK: - backgroundLayer
        let arcCenter = CGPoint.init(x: self.bounds.height / 2, y: self.bounds.height / 2)

        var radius: CGFloat = 0
        var linwWidth: CGFloat = 0
        if fixedWidth == nil {
            radius = MydayConstant.circleWith - MydayConstant.circleSpace
            linwWidth = MydayConstant.progressLineWidth
        }else {
            radius = fixedWidth!
            linwWidth = 5
        }

        let circlePat : UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
            CGFloat(radius), startAngle: CGFloat(rad(value: 0)) , endAngle: CGFloat(rad(value: 360)), clockwise: true)
        let  backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circlePat.cgPath
        backgroundLayer.lineWidth    = linwWidth
        backgroundLayer.lineCap      = kCALineCapRound
        backgroundLayer.lineJoin     = kCALineCapRound
        backgroundLayer.opacity = 0.3
        backgroundLayer.strokeColor  = mainColor.cgColor
        backgroundLayer.fillColor    = UIColor.clear.cgColor
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        self.layer.insertSublayer(backgroundLayer, at: 0)
    }

    fileprivate  func setColors(_ mydayModel: MydayModel?) {

        guard let _ = mydayModel else {
             mainColor = MainColor
            return
        }

        switch mydayModel!.type {
        case .walk:
            mainColor = MydayConstant.walkFillColor
        case .goal:
            mainColor = MydayConstant.percentFillColor
        case .heartRate:
            mainColor = MydayConstant.heartRateFillColor
        case .sportTime:
            mainColor = MydayConstant.sportTimeFillColor
        case .calorie:
            mainColor = MydayConstant.calorieFillColor
        case .sleepTime:
            mainColor = MydayConstant.sleepTimeFillColor
        case .bloodSugar:
            mainColor = UIColor.white
        case .distance:
            mainColor = MydayConstant.distanceFillColor
        default:
            mainColor = MainColor
        }
    }
    
}

// MARK: - Fileprivate func
extension MydayProgressView {
    fileprivate func rad (value:Double) -> Double {

        return value * Double.pi / 180.0
    }

}


