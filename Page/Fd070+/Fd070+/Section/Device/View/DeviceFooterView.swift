//
//  DeviceFooterView.swift
//  FD070+
//
//  Created by Payne on 2018/12/12.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class DeviceFooterView: UIView {
   
    var deleteBtnAction: (() -> ())?

    var deleteBtn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        deleteBtn.layer.masksToBounds = true
        deleteBtn.layer.cornerRadius = 15
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize:18)
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.backgroundColor = MainColor
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)

        addSubview(deleteBtn)
        let btnWidth = SCREEN_WIDTH  - 40
        deleteBtn.snp.makeConstraints { (make) in
            make.width.equalTo(btnWidth)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    @objc func deleteBtnClick(sender:UIButton){
        if (deleteBtnAction != nil) {
            self.deleteBtnAction!()
        }
    }
}
