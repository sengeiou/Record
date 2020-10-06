//
//  GeneralButton.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/11.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class GeneralButton: UIButton {

    //MARK:添加闭包
    var generalBtnAction: (() -> ())?
    
    var generalBtnTitle : NSString!
    
    
    init(frame: CGRect,generalBtnTitle: NSString) {
        super.init(frame: frame)
        self.generalBtnTitle = generalBtnTitle
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
        self.backgroundColor = MainColor
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.setTitle(self.generalBtnTitle! as String, for: .normal)
//        self.titleLabel?.font = UIFont.init(name: "Arial", size:Font(size: 20))
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        self.setTitleColor(.white, for: .normal)
        self.addTarget(self, action: #selector(generalBtnClick), for: .touchUpInside)
    }
    
    @objc func generalBtnClick(){
        
        if self.generalBtnAction != nil {
            self.generalBtnAction!()
        }
    }
    
}
