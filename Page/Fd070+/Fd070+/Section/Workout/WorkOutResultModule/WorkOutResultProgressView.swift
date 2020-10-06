//
//  WorkOutResultProgressView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkOutResultProgressView: UIView {
    
    fileprivate var progressLayer:CAShapeLayer!
    let backgroundLayer = CAShapeLayer()
    
    fileprivate var mainColor = UIColor()
    
    var model: WorkOutResultItemModel = WorkOutResultItemModel() {
        didSet {
            setData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setData() {
        mainColor = model.mainColor
        
        progressLayer.strokeEnd = model.progress
        progressLayer.strokeColor  = mainColor.cgColor
        
        backgroundLayer.strokeColor = mainColor.withAlphaComponent(0.2).cgColor
        layoutIfNeeded()
        
    }
    fileprivate func setUI() {
        
        insertBackgroundLayer()
        
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
        
        progressLayer.fillColor    = UIColor.clear.cgColor
        progressLayer.strokeStart = 0
        
        var progress = model.progress
        if progress < 0.01 {
            progress = 0.01
        }
        progressLayer.strokeEnd = progress
        
        self.layer.addSublayer(progressLayer)
    }
    
    private func addSubviews() {
        
    }
    fileprivate func insertBackgroundLayer() {
        // MARK: - backgroundLayer
        let arcCenter = CGPoint.init(x: self.bounds.height / 2, y: self.bounds.height / 2)
        let radius = MydayConstant.circleWith - MydayConstant.circleSpace
        
        let circlePat : UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
            CGFloat(radius), startAngle: CGFloat(rad(value: 0)) , endAngle: CGFloat(rad(value: 360)), clockwise: true)
        
        backgroundLayer.path = circlePat.cgPath
        backgroundLayer.lineWidth    = MydayConstant.progressLineWidth
        backgroundLayer.lineCap      = kCALineCapRound
        backgroundLayer.lineJoin     = kCALineCapRound
        
        backgroundLayer.fillColor    = UIColor.clear.cgColor
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        self.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    
}

// MARK: - Fileprivate func
extension WorkOutResultProgressView {
    fileprivate func rad (value:Double) -> Double {
        
        return value * Double.pi / 180.0
    }
    
}
