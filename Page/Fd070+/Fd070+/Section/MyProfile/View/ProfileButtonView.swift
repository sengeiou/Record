//
//  ProfileButtonView.swift
//  Orangetheory
//
//  Created by Payne on 2018/6/23.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class ProfileButtonView: UIView {
    
    let btnTest_width:CGFloat = 60
    let btnTest_higth:CGFloat = 30
    
    private var isBtnSelect:Bool!
    
    //MARK:添加闭包传回按钮tag值
    var profileBtnAction: ((NSInteger) -> ())?
    
    
    var btnTitleNumber:Int = 0 {
        
        didSet {
            
            if btnTitleNumber == 0
            {
                isBtnSelect = true
            }else{
                isBtnSelect = false
            }
            self.configUI()
        }
    }
    
    var btnTitleArr: NSArray = [] {
        
        didSet {
            self.configUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configUI(){
        
        
        let subViews = self.subviews
        for view in subViews {
            view.removeFromSuperview()
        }
        for i in 0..<self.btnTitleArr.count
        {
            let btn = UIButton(type: .custom)
            
            btn.frame = CGRect(x:CGFloat((i%2) + (i * 80)) + (SCREEN_WIDTH/2 - 80), y:CGFloat((i/2) * Int(btnTest_width)) + 5, width: btnTest_width, height: btnTest_higth)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 15
            btn.layer.borderWidth = 1.0
            btn.layer.borderColor = UIColor.clear.cgColor
            btn.titleLabel?.font = UIFont.systemFont(ofSize:18)
            btn.setTitle((self.btnTitleArr[i] as! String), for: .normal)
            btn.tag = i + 1000
            
            if i == 0 && isBtnSelect{                
                btn.isSelected = true
            }
            if i == 1 && !isBtnSelect
            {
                btn.isSelected = true
            }
            btn.setTitleColor(UIColor.hexColor(0x4c5256), for: .normal)
            btn.setTitleColor(.white, for: .selected)
            btn.setBackgroundImage(UIImage.getImageWithColor(color:MainColor), for: .selected)
            
            btn.setBackgroundImage(UIImage.getImageWithColor(color: UIColor.RGB(r: 133, g: 133, b: 133)), for: .normal)
            btn.addTarget(self, action: #selector(radioBtnClick(sender:)), for: .touchUpInside)
            self.addSubview(btn)
            
        }
    }
    
    
    @objc func radioBtnClick(sender:UIButton){
        
        if sender.isSelected == true {
            return;
        }
        let otherBtn:UIButton = self.viewWithTag(sender.tag==1000 ? 1001:1000) as! UIButton
        sender.isSelected = !sender.isSelected
        otherBtn.isSelected = !otherBtn.isSelected
        
        isBtnSelect = sender.tag == 1000 ? sender.isSelected :otherBtn.isSelected
        
        if self.profileBtnAction != nil {
            self.profileBtnAction!(sender.tag - 1000)
        }
    }
}
