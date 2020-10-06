//
//  DeviceHeaderView.swift
//  FD070+
//
//  Created by Payne on 2018/12/12.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class DeviceHeaderView: UIView {

    let firmwareLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x414141)
        $0.text = "DeviceVC_firmware".localiz()
    }


    let firmwareValueLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x436083)
        $0.text = "---"
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let serialNumberLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x414141)
        $0.text = "DeviceVC_serial".localiz()
    }
    let serialValueLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x436083)
        $0.text = "---"
    }
    let lastLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x414141)
        $0.text = "DeviceVC_lastAsyc".localiz()
    }
    let lastValueLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x436083)
        $0.text = "DeviceVC_lastAsyc_just".localiz()
    }
    let electricLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x414141)
        $0.text = "DeviceVC_electric".localiz()
    }
    let electricValueLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x436083)
        $0.text = "100%"
    }
    
    var iconImgView = UIImageView().then() {
        $0.image = UIImage.init(named: "Select_device")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func changeHeaderViewDisplay(deviceModel:DeviceInfoModel) {
        //        firmwareValueLabel.text = deviceModel.band_version

        firmwareValueLabel.text = UserDefaults.DeviceInfoUserDefault.Device_SoftVersion.storedValue as? String ?? "V0.0.1"


    }
    
    private func configUI() {
        

        addSubview(firmwareLabel)
        firmwareLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }

        addSubview(firmwareValueLabel)
        firmwareValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(firmwareLabel.snp.bottom)
            make.width.equalTo(140)
            make.height.equalTo(20)
        }

        addSubview(serialNumberLabel)
        serialNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(firmwareValueLabel.snp.bottom).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }

        addSubview(serialValueLabel)
        serialValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(serialNumberLabel.snp.bottom)
            make.width.equalTo(140)
            make.height.equalTo(20)
        }
        

        addSubview(lastLabel)
        lastLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(serialValueLabel.snp.bottom).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }

        addSubview(lastValueLabel)
        lastValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(lastLabel.snp.bottom)
            make.width.equalTo(140)
            make.height.equalTo(20)
        }

        addSubview(electricLabel)
        electricLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(lastValueLabel.snp.bottom).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }

        addSubview(electricValueLabel)
        electricValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(electricLabel.snp.bottom)
            make.width.equalTo(140)
            make.height.equalTo(20)
        }
        
        addSubview(iconImgView)
        iconImgView.snp.makeConstraints { (make) in
            make.left.equalTo(firmwareLabel.snp.right).offset(40)
            make.top.equalTo(20)
            make.width.equalTo(100)
            make.height.equalTo(230)
        }
    }
    
    
}
