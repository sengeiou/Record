//
//  FDGenderSelectButton.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class FDGenderSelectButton: UIView {

    var manButton = UIButton(type: .custom)
    var womanButton = UIButton(type: .custom)

    let manLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x494949)
        $0.text = "UserInforGenderVC_male".localiz() 
        $0.textAlignment = NSTextAlignment.center
    }
    let womanLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x494949)
        $0.text = "UserInforGenderVC_female".localiz()
        $0.textAlignment = NSTextAlignment.center
    }
    
    var buttonNum:Int = 0 {
        
        didSet {
            
            if buttonNum == 0 {
                isManButtonSelect()
            }else{
                isWomanButtonSelect()
            }
            self.configUI()
        }
    }
    
    
    var genderBtnAction: ((NSInteger) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        //        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){

        manButton.addTarget(self, action: #selector(manButtonClick), for: .touchUpInside)
        addSubview(manButton)
        manButton.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview().multipliedBy(0.5)
        }
        
        womanButton.addTarget(self, action: #selector(womanButtonClick), for: .touchUpInside)
        addSubview(womanButton)
        womanButton.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
        addSubview(manLabel)
        manLabel.snp.makeConstraints { (make) in
            make.top.equalTo(manButton.snp.bottom)
            make.left.equalTo(50)
            make.width.equalTo((SCREEN_WIDTH - 110)/3)
            make.height.equalTo(50)
        }
        
        addSubview(womanLabel)
        womanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(womanButton.snp.bottom)
            make.right.equalTo(-50)
            make.width.equalTo((SCREEN_WIDTH - 110)/3)
            make.height.equalTo(50)
        }
        

    }
    
    func isManButtonSelect(){
        manButton.setBackgroundImage(UIImage.init(named: "Gender_mansel"), for: .normal)
        womanButton.setBackgroundImage(UIImage.init(named: "Gender_woman"), for: .normal)
        manLabel.textColor = UIColor.hexColor(0x494949)
        womanLabel.textColor = UIColor.hexColor(0x656565)
    }
    
    func isWomanButtonSelect(){
        manButton.setBackgroundImage(UIImage.init(named: "Gender_man"), for: .normal)
        womanButton.setBackgroundImage(UIImage.init(named: "Gender_womansel"), for: .normal)
        manLabel.textColor = UIColor.hexColor(0x656565)
        womanLabel.textColor = UIColor.hexColor(0x494949)
    }
    
    @objc func manButtonClick(){
        isManButtonSelect()
        if genderBtnAction != nil {
            genderBtnAction!(0)
        }
    }
    
    @objc func womanButtonClick(){
        
        isWomanButtonSelect()
        if genderBtnAction != nil {
            genderBtnAction!(1)
        }
    }

}
