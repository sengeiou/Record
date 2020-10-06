//
//  MydayHeadView.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/17.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

public typealias didClickConnectBlock = (_ tag:Int,_ type:MydayHeaderViewState) -> ()

public enum MydayHeaderViewState:Int {
    
    case HeaderView_Unknow_State = 0
    
    case HeaderView_Connected_State
    
    case HeaderView_Disconnect_State
}
enum HeadViewType {
    case myDay
    case history

}
class MydayHeadView: UIView {

    private var bandIconImgView = UIImageView()
    public var connectStateButton = UIButton().then() {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    private var typeButton = UIButton().then() {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.titleLabel?.textColor = UIColor.white
    }

    public var didCleckConnectBtn : didClickConnectBlock?

    public var didCleckTypeBtn : (() -> ())?

    private var connectState:MydayHeaderViewState?

    private var type = HeadViewType.myDay

    init(type: HeadViewType) {
        self.type = type

        super.init(frame: CGRect.zero)
        configUI()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {

        bandIconImgView.image = UIImage.init(named: "band_connection")
        addSubview(bandIconImgView)
        bandIconImgView.snp.makeConstraints { (make) in
            make.left.equalTo(MydayConstant.collectionCellSpace)
            make.centerY.equalToSuperview()
        }

        connectStateButton.setTitle("Myday_BLEConnect_point".localiz(), for: .normal)
        connectStateButton.addTarget(self, action: #selector(clickBleConnectBtn(sender:)), for: .touchUpInside)
        addSubview(connectStateButton)
        connectStateButton.snp.makeConstraints { (make) in
            make.left.equalTo(bandIconImgView.snp.right).offset(MydayConstant.collectionCellSpace * 3)
            make.centerY.equalToSuperview()
        }

        if type == .myDay {
            let currentDate = FDDateHandleTool.getCurrentDate(dateType: "yyyy/MM/dd")
            typeButton.setTitle(currentDate, for: .normal)
        }else {
            typeButton.setImage(UIImage.init(named: "calendar_icon"), for: .normal)
        }

        typeButton.addTarget(self, action: #selector(clickTypeBtn(sender:)), for: .touchUpInside)
        addSubview(typeButton)
        typeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-MydayConstant.collectionCellSpace)
            make.centerY.equalToSuperview()
        }

    }
    
    
    func changeMyHeaderViewDisplay(_ state:MydayHeaderViewState, _ deviceName:String) {
        connectState = state
        switch state {
        case .HeaderView_Unknow_State:
            connectStateButton.setTitle("Myday_BLEConnect_point".localiz(), for: .normal)
            bandIconImgView.image = UIImage.init(named: "band_broken")
            break
        case .HeaderView_Connected_State:
            let connectState = "Myday_BLEConnectState_true".localiz()
            connectStateButton.setTitle("\(deviceName)" + connectState, for: .normal)
            bandIconImgView.image = UIImage.init(named: "band_connection")
            break;
        case .HeaderView_Disconnect_State:
            let connectState = "Myday_BLEConnectState_false".localiz()
            connectStateButton.setTitle("\(deviceName)" + connectState, for: .normal)
            bandIconImgView.image = UIImage.init(named: "band_broken")
            break
        }
    }
    
    
    @objc func clickBleConnectBtn(sender:UIButton) {
        
        if self.didCleckConnectBtn != nil {
            self.didCleckConnectBtn!(sender.tag,connectState!)
        }
    }

    @objc func clickTypeBtn(sender:UIButton) {

        if self.didCleckTypeBtn != nil {
            self.didCleckTypeBtn!()
        }
    }

}
