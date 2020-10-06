//
//  UserInfoHeaderView.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class UserInfoHeaderView: UIView {

    
    let titleLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x3d3d3d)
        $0.font = UIFont.boldSystemFont(ofSize: 17.0)
        $0.textAlignment = NSTextAlignment.center
    }
    let progress = FDProgressView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
    
        addSubview(progress)
        progress.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(10)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(progress.snp.bottom)
            make.left.right.equalTo(progress)
            make.height.equalTo(50)
        }
    }
    func getProgressValueAndTitle(progressValue:Float,title:String){
        progress.setProgress(progress: progressValue)
        titleLabel.text = title
    }
    func isHidenProgress(hidden:Bool){
        progress.isHidden = hidden
    }
    
    
}
