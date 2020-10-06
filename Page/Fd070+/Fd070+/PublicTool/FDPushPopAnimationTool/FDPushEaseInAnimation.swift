//
//  FDPushEaseInAnimation.swift
//  DemoSummarySwift
//
//  Created by WANG DONG on 2018/7/9.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

protocol FDPushEaseInAnimationPro {
    var triggerButton: UIButton { get }
    var mainView: UIView { get }
}

class FDPushEaseInAnimation: NSObject,UIViewControllerAnimatedTransitioning,CAAnimationDelegate {

    var duration = 0.3
    var transitionContextPush:UIViewControllerContextTransitioning? = nil
    
    
    // 返回动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? FDPushEaseInAnimationPro,
            let toVC = transitionContext.viewController(forKey: .to) as? WorkoutInforViewController,
            let snapshot = fromVC.mainView.snapshotView(afterScreenUpdates: false) else {
                transitionContext.completeTransition(false)
                return
        }
        
        transitionContextPush = transitionContext
        
        let containerView = transitionContext.containerView
        
        //Background View With Correct Color
        let backgroundView = UIView()
        backgroundView.frame = toVC.view.frame
        backgroundView.backgroundColor = fromVC.mainView.backgroundColor
        containerView.addSubview(backgroundView)
        
        //Animate old view offscreen
        containerView.addSubview(snapshot)
        fromVC.mainView.removeFromSuperview()
        
        //Growing Circular Mask
        containerView.addSubview(toVC.view)
        animate(toView: toVC.view, fromTriggerButton: fromVC.triggerButton)
    }
    
    func animate(toView: UIView, fromTriggerButton triggerButton: UIButton) {
        //Starting Path
        let rect = CGRect(x: triggerButton.frame.origin.x,
                          y: triggerButton.frame.origin.y,
                          width: triggerButton.frame.width,
                          height: triggerButton.frame.width)
        let circleMaskPathInitial = UIBezierPath(ovalIn: rect)
        
        //Destination Path
        let fullHeight = toView.bounds.height
        let fullWidth = toView.bounds.width
        
        let extremePoint = CGPoint(x: triggerButton.center.x,
                                   y: triggerButton.center.y)
        
        let radiusOne = Double(sqrt(pow(extremePoint.x, 2)+pow(extremePoint.x, 2)))
        let radiusTwo = Double(sqrt(pow((fullWidth-extremePoint.x), 2)+pow(extremePoint.x, 2)))
        let radiusThree = Double(sqrt(pow(extremePoint.x, 2)+pow((fullHeight-extremePoint.y), 2)))
        let radiusFour = Double(sqrt(pow((fullWidth-extremePoint.x), 2)+pow((fullHeight-extremePoint.y), 2)))

        let radiusMax = [radiusOne,radiusTwo,radiusThree,radiusFour].max()!+50
        
        let circleMaskPathFinal = UIBezierPath(ovalIn: triggerButton.frame.insetBy(dx: CGFloat(-radiusMax),
                                                                                   dy: CGFloat(-radiusMax)))
        
        //Actual mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toView.layer.mask = maskLayer
        
        //Mask Animation
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.delegate = self
        maskLayerAnimation.duration = 0.5
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Push 动画已经完成")
        transitionContextPush?.completeTransition(true)
    }
    
}
