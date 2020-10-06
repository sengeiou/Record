//
//  WorkOutCountDownView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkOutCountDownView: UIView {

    struct Constant {
        
        static let mainBGColor = UIColor.RGB(r: 0, g: 125, b: 255)
    }

    private lazy var countDownLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let countDownTitleArr :[String] = ["3",
                                       "2",
                                       "1",
                                       "GO!"]
    var groupAnimationUpBig: CAAnimationGroup!
    var groupAnimationUpSmaller: CAAnimationGroup!

    var countDownOverBlock: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {

        self.backgroundColor = Constant.mainBGColor

        countDownLabel.frame = self.bounds
        countDownLabel.backgroundColor = .clear
        countDownLabel.textColor = .white
        countDownLabel.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: 110.auto())
        countDownLabel.textAlignment = NSTextAlignment.center
        countDownLabel.tag = 0;
        countDownLabel.text = countDownTitleArr[countDownLabel.tag];
        self.addSubview(countDownLabel)


        createAnimationGroup()
        countDownLabel.layer.add(groupAnimationUpBig, forKey: "scaleAnimUpBig")
        countDownLabel.layer.add(groupAnimationUpSmaller, forKey: "scaleAnimUpSmaller")
    }

    private func createAnimationGroup() {
        // 创建组动画
        groupAnimationUpBig = CAAnimationGroup()
        groupAnimationUpBig.beginTime = CACurrentMediaTime()
        groupAnimationUpBig.duration = 0.5
        groupAnimationUpBig.repeatCount = 1
        groupAnimationUpBig.delegate = self
        groupAnimationUpBig.isRemovedOnCompletion = false
        groupAnimationUpBig.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        groupAnimationUpBig.fillMode = kCAFillModeForwards

        groupAnimationUpSmaller = CAAnimationGroup()
        groupAnimationUpSmaller.beginTime = CACurrentMediaTime() + 0.8
        groupAnimationUpSmaller.repeatCount = 1
        groupAnimationUpSmaller.duration = 0.2
        groupAnimationUpSmaller.delegate = self
        groupAnimationUpSmaller.isRemovedOnCompletion = false
        groupAnimationUpSmaller.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        groupAnimationUpSmaller.fillMode = kCAFillModeForwards


        let animationBigScale = CABasicAnimation(keyPath: "transform.scale")
        animationBigScale.fromValue = NSNumber(value:0.15)
        animationBigScale.toValue = NSNumber(value:1)


        let animationBigPosition = CABasicAnimation(keyPath: "position")
        animationBigPosition.fromValue = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT-80)
        animationBigPosition.toValue =  CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)


        let animationSmallerScale = CABasicAnimation(keyPath: "transform.scale")
        animationSmallerScale.fromValue = 1
        animationSmallerScale.toValue = 0.15

        let animationSmallerP = CABasicAnimation(keyPath: "position")
        animationSmallerP.fromValue = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
        animationSmallerP.toValue =  CGPoint(x: SCREEN_WIDTH/2, y: 80)

        groupAnimationUpBig.animations = [animationBigScale, animationBigPosition]
        groupAnimationUpSmaller.animations = [animationSmallerScale, animationSmallerP]
    }
}
extension WorkOutCountDownView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        if (anim == self.countDownLabel.layer.animation(forKey: "scaleAnimUpSmaller"))
        {
            if (self.countDownLabel.tag == self.countDownTitleArr.count - 1)
            {


                DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                    self.countDownLabel.text = ""
                    if self.countDownOverBlock != nil {
                        self.countDownOverBlock!()
                    }
                }
            }
            else
            {
                self.countDownLabel.tag += 1
                self.countDownLabel.text = self.countDownTitleArr[self.countDownLabel.tag]
                createAnimationGroup()
                if self.countDownLabel.tag == self.countDownTitleArr.count - 1
                {
                    countDownLabel.layer.add(groupAnimationUpBig, forKey: "scaleAnimUpSmaller")
                }
                else
                {

                    countDownLabel.layer.add(groupAnimationUpBig, forKey: "scaleAnimUpBig")
                    countDownLabel.layer.add(groupAnimationUpSmaller, forKey: "scaleAnimUpSmaller")
                }
            }
        }
    }
}
