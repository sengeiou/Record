//
//  OtaUploadMaskView.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/26.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

enum OtaUploadState:Int {
    case OTAState_success = 0
    
    case OTAState_Failure
}

class OtaUploadMaskView: UIView {
    
    var progressView: MydayProgressView!

    var contentView:UIView!
    
    var stateLabel: UILabel!
    var tipLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.initDisplayData()
        self.initDisplayView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initDisplayData() {
        
    }
    
    func initDisplayView() {
        
        //Content View
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH * 0.84, height: SCREEN_HEIGHT * 0.263))
        contentView.center = self.center
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        addSubview(contentView)

        //title
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.text = "OTAVC_title".localiz()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }

        //Dividing line
        let lineLayer = CALayer()
        lineLayer.frame = CGRect.init(x: 10, y: 30, width: contentView.width - 20, height: 0.5)
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        contentView.layer.addSublayer(lineLayer)

        //Progress view
        let progressViewWidth = contentView.width * 0.2
        progressView = MydayProgressView.init(frame: CGRect.init(x: (contentView.width - progressViewWidth) / 2, y:(contentView.height - progressViewWidth) / 2, width: progressViewWidth, height: progressViewWidth))
        contentView.addSubview(progressView)


        tipLabel = UILabel()
        tipLabel.textColor = UIColor.black
        tipLabel.font = UIFont.boldSystemFont(ofSize: 10)
        tipLabel.text = "OTAVC_keepBLEConnect".localiz()
        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }

        stateLabel = UILabel()
        stateLabel.textColor = MainColor
        stateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        stateLabel.text = "OTAVC_firmwareUpgrade".localiz()
        contentView.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tipLabel.snp.top).inset(-10)
        }

    }
    
    
    
    
    func changeOTaProgress(progress:Int) {

        stateLabel.text = "OTAVC_Loading".localiz()
        progressView.progress = CGFloat(Double(progress)/100.0)
    }
    
    
    func changeOtaViewDisplay(state:OtaUploadState) {
        switch state {
        case .OTAState_success:
            tipLabel!.text = "OTAVC_updateCompleted".localiz()
            stateLabel!.text = "OTAVC_deviceRestartPleaseReconnect".localiz()
            break
        case .OTAState_Failure:
            tipLabel!.text = "OTAVC_upgradeFailure".localiz()
            stateLabel!.text = "OTAVC_tryAgain".localiz()
            break
        }
    }
    
}
