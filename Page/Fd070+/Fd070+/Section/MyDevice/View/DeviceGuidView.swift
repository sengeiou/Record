//
//  DeviceGuidView.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/18.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

public enum deviceGuidBtnTag:Int {
    
    case startPairTag = 1000
    
    case noPairTag = 1001
}

public typealias didClickBtnBlock = (_ tag: Int) -> ()

class DeviceGuidView: UIView {

    public var didCleckBlock : didClickBtnBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        initDisplayData()
        initDisplayView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initDisplayData(){
        
    }
    
    func initDisplayView(){
    
        let imageView:UIImageView = UIImageView(image: UIImage.init(named: "Scan_device"))
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(40)
            maker.centerX.equalTo(self)
            maker.width.equalTo(65)
            maker.height.equalTo(162)
        }
        
        let titleDescribLabel = UILabel()
        self.addSubview(titleDescribLabel)
        titleDescribLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(20)
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-20)
            maker.height.equalTo(60)
        }
        
        titleDescribLabel.text = "DeviceSelectVC_connect_message".localiz()
        titleDescribLabel.textAlignment = .center
        titleDescribLabel.textColor = .black
        titleDescribLabel.numberOfLines = 0
        titleDescribLabel.font = UIFont.systemFont(ofSize: 18)
        
        
        
        let startPairBtn = GeneralButton(frame: CGRect.zero, generalBtnTitle: "DeviceSelectVC_connect_start".localiz() as NSString)
        
        startPairBtn.generalBtnAction = {
            if self.didCleckBlock != nil {
                self.didCleckBlock!(startPairBtn.tag)
            }
        }
        
        self.addSubview(startPairBtn)
        startPairBtn.tag = deviceGuidBtnTag.startPairTag.rawValue
        startPairBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.snp.bottom).offset(-30)
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-20)
            maker.height.equalTo(50)
        }
        
        
        
        let noPairBtn = GeneralButton(frame: CGRect.zero, generalBtnTitle: "DeviceSelectVC_connect_after".localiz() as NSString)
        noPairBtn.tag = deviceGuidBtnTag.noPairTag.rawValue
        noPairBtn.generalBtnAction = {
            if self.didCleckBlock != nil {
                self.didCleckBlock!(noPairBtn.tag)
            }
        }
        
        self.addSubview(noPairBtn)
        
        noPairBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(startPairBtn.snp.top).offset(-10)
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-20)
            maker.height.equalTo(40)
        }
        
        noPairBtn.backgroundColor = .white
        noPairBtn.setTitleColor(.black, for: .normal)
        noPairBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }

}
