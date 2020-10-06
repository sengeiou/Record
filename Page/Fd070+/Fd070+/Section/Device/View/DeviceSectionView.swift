//
//  DeviceSectionView.swift
//  FD070+
//
//  Created by Payne on 2018/12/12.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class DeviceSectionView: UIView {

    let dayDateLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x383838)
        $0.font = UIFont.boldSystemFont(ofSize: 22)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
      
        addSubview(dayDateLabel)
        dayDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }

}
