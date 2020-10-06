//
//  CircularProgressView.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/26.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    fileprivate var contentLayer:CAShapeLayer!
    fileprivate var progressLayer:CAShapeLayer!
    fileprivate var endPointLayer: CAShapeLayer!

    fileprivate var backgroundLayer: CAShapeLayer!

    fileprivate var topColors = [UIColor]()
    fileprivate var bottomColors = [UIColor]()

    var isShowBGLayer:Bool = false {
        didSet {
            setUI()
        }
    }

    var widthWidth:CGFloat = 15.auto() {
        didSet {
            setUI()
        }
    }
    var mainColor: UIColor = MydayConstant.bloodSugarFillColor {
        didSet {
            setUI()
        }
    }

    /// range [0,1]
    var progress:CGFloat = 0 {
        didSet {
            if progress == CGFloat(1) {
                endPointLayer.isHidden = false
            }else {
                endPointLayer.isHidden = true
            }
            progressLayer.strokeEnd = progress
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate  func setUI() {

        let lighterColor = mainColor.lighterColor
        topColors = [lighterColor,mainColor]
        bottomColors = [lighterColor,UIColor.white]

        contentLayer = CAShapeLayer()
        contentLayer.frame = self.bounds
        self.layer.addSublayer(contentLayer)

        /// TopLayer
        let topLayer = CAGradientLayer()
        topLayer.frame  = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height / 2)
        topLayer.colors = topColors.map({ (color) -> CGColor in
            return color.cgColor
        })
        topLayer.locations     = [0.20,1]
        topLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        topLayer.endPoint   = CGPoint.init(x: 1, y: 0.5)
        contentLayer.addSublayer(topLayer)

        /// BottomLayer
        let bottomLayer = CAGradientLayer()
        bottomLayer.frame  = CGRect.init(x: 0, y: self.bounds.height / 2, width: self.bounds.width, height: self.bounds.height / 2)
        bottomLayer.colors = bottomColors.map({ (color) -> CGColor in
            return color.cgColor
        })
        bottomLayer.locations     = [0.20,1]
        bottomLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        bottomLayer.endPoint   = CGPoint.init(x: 1, y: 0.5)
        contentLayer.addSublayer(bottomLayer)

        // MARK: - ProgressLayer
        progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        let arcCenter = CGPoint.init(x: self.bounds.height / 2, y: self.bounds.height / 2)
        let radius = (self.width / 2) - 30.auto()
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
            CGFloat(radius), startAngle: CGFloat(rad(value: 0)) , endAngle: CGFloat(rad(value: 360)), clockwise: true)
        progressLayer.path = circlePath.cgPath
        progressLayer.lineWidth    = widthWidth
        progressLayer.lineCap      = kCALineCapRound
        progressLayer.lineJoin     = kCALineCapRound
        progressLayer.strokeColor  = UIColor.black.cgColor
        progressLayer.fillColor    = UIColor.clear.cgColor
        progressLayer.strokeStart = 0.02
        progressLayer.strokeEnd = progress
        contentLayer.mask = progressLayer


        // MARK: - Endpoint
        endPointLayer = CAShapeLayer()
        let endPointPath = UIBezierPath.init(ovalIn: CGRect.init(x: self.bounds.width - (widthWidth / 2) - widthWidth, y: (self.bounds.height / 2) - (widthWidth / 2)  , width: widthWidth, height: widthWidth))
        endPointLayer.path = endPointPath.cgPath
        endPointLayer.fillColor = mainColor.cgColor
        endPointLayer.shadowColor = mainColor.cgColor
        endPointLayer.shadowOffset = CGSize.init(width: 0, height: 5)
        endPointLayer.shadowOpacity = 0.15
        endPointLayer.shadowRadius = 3

        contentLayer.addSublayer(endPointLayer)


        if !isShowBGLayer {
            return
        }

        // MARK: - backgroundLayer

        let circlePat : UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
            CGFloat(radius), startAngle: CGFloat(rad(value: 0)) , endAngle: CGFloat(rad(value: 360)), clockwise: true)
        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circlePat.cgPath
        backgroundLayer.lineWidth    = widthWidth
        backgroundLayer.lineCap      = kCALineCapRound
        backgroundLayer.lineJoin     = kCALineCapRound
        backgroundLayer.opacity = 0.3
        backgroundLayer.strokeColor  = UIColor.gray.cgColor
        backgroundLayer.fillColor    = UIColor.clear.cgColor
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        self.layer.insertSublayer(backgroundLayer, at: 0)
    }

}

// MARK: - Fileprivate func
extension CircularProgressView {
    fileprivate func rad (value:Double) -> Double {
        return value * Double.pi / 180.0
    }
}
extension CircularProgressView {
    func startAnimation() {

        contentLayer.removeAllAnimations()
        
        let baseAnimation = CABasicAnimation(keyPath: "transform.rotation")
        baseAnimation.duration = 2
        baseAnimation.fromValue = 0
        baseAnimation.toValue = Double.pi * 2
        baseAnimation.repeatCount = HUGE
        baseAnimation.isRemovedOnCompletion = true

        contentLayer.add(baseAnimation, forKey: "contentLayer.baseAnimation")

    }
    func endAnimation() {
//        let pausedTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
//        contentLayer.speed = 0.0
//        contentLayer.timeOffset = pausedTime
        contentLayer.removeAnimation(forKey: "contentLayer.baseAnimation")
    }
}



