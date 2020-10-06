//
//  DialStyleTableViewCell.swift
//  FD070+
//
//  Created by Payne on 2018/12/12.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class DialStyleTableViewCell: UITableViewCell {

    var DialStyleBtnAction: ((NSInteger) -> ())?
    
    var leftImgView = UIImageView().then() {
        $0.backgroundColor = .white
    }
    var rightImgView = UIImageView().then() {
        $0.backgroundColor = .white
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize:18)
        leftBtn.setTitleColor(.white, for: .normal)
        leftBtn.backgroundColor = MainColor
        leftBtn.setBackgroundImage(UIImage.init(named: "time_1"), for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBtnClick(sender:)), for: .touchUpInside)
        addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(50)
            make.width.equalTo(85)
            make.height.equalTo(140)
        }

        addSubview(leftImgView)
        leftImgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.height.equalTo(20)
            make.centerX.equalTo(leftBtn.snp.centerX)
        }


        
        
        let rightBtn = UIButton(type: .custom)

        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize:18)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.backgroundColor = MainColor
        rightBtn.addTarget(self, action: #selector(rightBtnClick(sender:)), for: .touchUpInside)
        rightBtn.setBackgroundImage(UIImage.init(named: "time_2"), for: .normal)
        addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(leftBtn.snp.right).offset(50)
            make.width.equalTo(85)
            make.height.equalTo(140)
        }
        
        addSubview(rightImgView)
        rightImgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.height.equalTo(20)
            make.centerX.equalTo(rightBtn.snp.centerX)
        }
        
        //创建路径
        let linePath = UIBezierPath()
        //起点
        linePath.move(to: CGPoint.init(x: 10, y: 15))
        //添加其他点
        linePath.addLine(to: CGPoint.init(x: 0, y: 0))
        linePath.addLine(to: CGPoint.init(x: 20, y: 0))
        //闭合路径
        linePath.close()
        
        //设施路径画布
        let lineShape = CAShapeLayer()
        lineShape.frame = CGRect.init(x: 0, y: 0, width: 20, height: 15)
        lineShape.lineWidth = 2
        lineShape.lineJoin = kCALineJoinMiter
        lineShape.lineCap = kCALineCapSquare
        lineShape.strokeColor = UIColor.hexColor(0xd1cfcf).cgColor
        lineShape.path = linePath.cgPath
        lineShape.fillColor = UIColor.hexColor(0xd1cfcf).cgColor
        leftImgView.layer.addSublayer(lineShape)
        
        //设施路径画布
        let lineShape1 = CAShapeLayer()
        lineShape1.frame = CGRect.init(x: 0, y: 0, width: 20, height: 15)
        lineShape1.lineWidth = 2
        lineShape1.lineJoin = kCALineJoinMiter
        lineShape1.lineCap = kCALineCapSquare
        lineShape1.strokeColor = UIColor.hexColor(0xd1cfcf).cgColor
        lineShape1.path = linePath.cgPath
        lineShape1.fillColor = UIColor.hexColor(0xd1cfcf).cgColor
        rightImgView.layer.addSublayer(lineShape1)
        

    }
    
    func selectIsLeft(){
        leftImgView.isHidden = false
        rightImgView.isHidden = true
    }
    func selectIsRight(){
        
        leftImgView.isHidden = true
        rightImgView.isHidden = false
    }
    
    func setBtnNumberWith(tag:NSInteger){
        if tag == 0 {
            self.selectIsLeft()
        }
        if tag == 1 {
            self.selectIsRight()
        }
    }
    
    
    @objc func leftBtnClick(sender:UIButton){
        self.selectIsLeft()

        self.DialStyleBtnAction!(0)

    }
    @objc func rightBtnClick(sender:UIButton){
        self.selectIsRight()

        self.DialStyleBtnAction!(1)

    }
}
