//
//  RotatePlateView.swift
//  angou
//
//  Created by ZippyZhao on 23/11/2016.
//  Copyright © 2016 ZippyZhao. All rights reserved.
//

import Foundation
import UIKit

class RotatePlateView: UIView {
    
    //减速定时器
    //子试图数量
    var numOfSubView = 0
    
    //大圆盘
    var circleView: UIImageView!
    
    //子试图数组
    var subViewArray = [UIButton]()
    //第一触碰点
    var beginPoint = CGPoint.zero
    //第二触碰点
    var movePoint = CGPoint.zero
    //正在跑
    var isPlaying = false
    //滑动时间
    var date: Date!
    var startTouchDate: Date!
    var decelerTime = 0
    //减速计数
    
    //子试图大小
    var subViewSize = CGSize.zero
    var pgr: UIPanGestureRecognizer!
    //转动的角度
    var StartAngle: CGFloat = 0.0
    //转动临界速度，超过此速度便是快速滑动，手指离开仍会转动
    var FlingableValue:Float = 0
    //半径
    var Radius:CGFloat = 0
    
    var btnArray = [UIButton]()
    var TmpAngle: CGFloat = 0.0
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     - (void)drawRect:(CGRect)rect {
     // Drawing code
     }
     */
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.decelerTime = 0
        self.subViewArray = [UIButton]()
        self.circleView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(frame.size.width), height: CGFloat(frame.size.height)))
//        if .image == nil {
            self.circleView.backgroundColor = ColorUtil.blackAlpha2()
            self.circleView.layer.cornerRadius = frame.size.width / 2
//        }
//        else {
//            self.circleView.image = UIImage()
//            self.circleView.backgroundColor = UIColor.clear
//        }
        Radius = frame.size.width / CGFloat(2)
        StartAngle = 0
        FlingableValue = 300
        self.isPlaying = false
        self.circleView.isUserInteractionEnabled = true
        self.addSubview(circleView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  加子视图
    
    func addSubView(withSubView imageArray: [Any], andTitle titleArray: [Any], andSize size: CGSize, andcenterImage centerImage: UIImage?) {
        self.subViewSize = size
        if titleArray.count > 0 {
            self.numOfSubView = titleArray.count
        }else if imageArray.count > 0 {
            self.numOfSubView = imageArray.count
        }
        btnArray = [UIButton]()
        for i in 0..<numOfSubView {
            let button = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            if imageArray.count==0 {
                button.backgroundColor = UIColor.yellow
                button.layer.cornerRadius = size.width / 2
            }
            else {
                if let img = imageArray[i] as? UIImage{
                    button.setImage(img, for: .normal)
                }
            }
            button.setTitleColor(UIColor.black, for: .normal)
            if let title = titleArray[i] as? String{
                button.setTitle(title, for: .normal)
            }
            button.tag = 100 + i
            btnArray.append(button)
            subViewArray.append(button)
            circleView.addSubview(button)
        }
        self.layoutBtn()
        //中间视图
        let buttonCenter = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.frame.size.width / 3.0), height: CGFloat(self.frame.size.height / 3.0)))
        buttonCenter.tag = 100 + numOfSubView + 1
        if let centerImage = centerImage {
            buttonCenter.setImage(centerImage, for: .normal)
        }else{
            buttonCenter.layer.cornerRadius = self.frame.size.width / 6.0
            buttonCenter.backgroundColor = UIColor.red
            buttonCenter.setTitleColor(UIColor.black, for: .normal)
            buttonCenter.setTitle("中间", for: .normal)
        }
        
        buttonCenter.center = CGPoint(x: CGFloat(self.frame.size.width / 2), y: CGFloat(self.frame.size.height / 2))
        subViewArray.append(buttonCenter)
        circleView.addSubview(buttonCenter)
        //加转动手势
        self.pgr = UIPanGestureRecognizer(target: self, action: #selector(self.zhuanPgr))
        circleView.addGestureRecognizer(pgr)
        //加点击效果
        for i in 0..<subViewArray.count {
            let button = subViewArray[i]
            self.bringSubview(toFront: button)
            button.addTarget(self, action: #selector(self.subViewOut), for: .touchUpInside)
        }
    }
    //按钮布局
    
    func layoutBtn() {
        let pi:CGFloat = 3.14
        
        for i in 0..<numOfSubView {
            let p:CGFloat = CGFloat(i) / CGFloat(numOfSubView)
            let angle = p * pi * CGFloat(2) + StartAngle
            // 178,245
            let yy: CGFloat = 200 + sin(angle) * (self.frame.size.width / 2 - subViewSize.width / 2 - 20)
            let xx: CGFloat = 200 + cos(angle) * (self.frame.size.width / 2 - subViewSize.width / 2 - 20)
            let button = btnArray[i]
            button.center = CGPoint(x: xx, y: yy)
        }
    }
    var flowtime: Timer!
    var anglePerSecond: CGFloat = 0.0
    var speed: CGFloat = 0.0
    //转动速度
    // MARK: - 转动手势
    
    func zhuanPgr(_ pgr: UIPanGestureRecognizer) {
        //    UIView *view=pgr.view;
        if pgr.state == .began {
            TmpAngle = 0
            beginPoint = pgr.location(in: self)
            startTouchDate = Date()
        }
        else if pgr.state == .changed {
            let StartAngleLast  = StartAngle
            movePoint = pgr.location(in: self)
            let start = self.getAngle(beginPoint)
            //获得起始弧度
            let end = self.getAngle(movePoint)
            //结束弧度
            if self.getQuadrant(movePoint) == 1 || self.getQuadrant(movePoint) == 4 {
                StartAngle += end - start
                TmpAngle += end - start
                //            NSLog(@"第一、四象限____%f",mStartAngle);
            }
            else {
                StartAngle += start - end
                TmpAngle += start - end
                //            NSLog(@"第二、三象限____%f",mStartAngle);
                //             NSLog(@"mTmpAngle is %f",mTmpAngle);
            }
            self.layoutBtn()
            beginPoint = movePoint
            speed = StartAngle - StartAngleLast
            print("speed is \(speed)")
        }
        else if pgr.state == .ended {
            // 计算，每秒移动的角度
            let time = Date().timeIntervalSince(startTouchDate)
            anglePerSecond = TmpAngle * 50 / CGFloat(time)
            print("anglePerSecond is \(anglePerSecond)")
            // 如果达到该值认为是快速移动
            if fabsf(Float(anglePerSecond)) > FlingableValue && !isPlaying {
                // post一个任务，去自动滚动
                self.isPlaying = true
                flowtime = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.flowAction), userInfo: nil, repeats: true)
            }
        }
        
    }
    //获取当前点弧度
    
    func getAngle(_ point: CGPoint) -> CGFloat {
        let x = point.x - Radius
        let y = point.y - Radius
        return CGFloat(asin(y / hypot(x, y)))
    }
    /**
     * 根据当前位置计算象限
     *
     * @param x
     * @param y
     * @return
     */
    
    func getQuadrant(_ point: CGPoint) -> Int {
        let tmpX = Int(point.x - Radius)
        let tmpY = Int(point.y - Radius)
        if tmpX >= 0 {
            return tmpY >= 0 ? 1 : 4
        }
        else {
            return tmpY >= 0 ? 2 : 3
        }
    }
    
    func flowAction() {
        if speed < 0.1 {
            self.isPlaying = false
            flowtime.invalidate()
            flowtime = nil
            return
        }
        // 不断改变mStartAngle，让其滚动，/30为了避免滚动太快
        StartAngle += speed
        speed = speed / 1.1
        // 逐渐减小这个值
        //    anglePerSecond /= 1.1;
        self.layoutBtn()
    }
    
    func subViewOut(button: UIButton) {
        //点击
//        if self.clickSomeOne {
//            
//        }
    }
}
