//
//  FDProgressView.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class FDProgressView: UIView {

    var progressView = UIProgressView(progressViewStyle:UIProgressViewStyle.default)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
        
        progressView.center = self.center
        progressView.frame = CGRect(x: 0, y: 0, width:SCREEN_WIDTH - 40, height: 10)
        progressView.progressTintColor = MainColor  //已有进度颜色
        progressView.trackTintColor = UIColor.hexColor(0xd8d8d8)  //剩余进度颜色（即进度槽颜色）
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 2.5
        self.addSubview(progressView)
    }
    
    func setProgress(progress:Float){
        
        progressView.setProgress(progress,animated:false)
    }
}
