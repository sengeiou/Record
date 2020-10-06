//
//  BoodSugarTestViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/3.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib

class BloodSugarTestViewController: BaseViewController {

    private struct Constant {
        static let margin: CGFloat = 20.auto()
    }
    
    let bledatamanage = BleDataManager.instance
    

    var messageTopLabel = UILabel().then() {
        $0.font = UIFont.systemFont(ofSize: 18.auto())
        $0.textColor = .gray
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = ""
    }

    var progressView: BoodSugarTestProgressView!
    
    var messageBottomLabel = UILabel().then() {
        $0.font = UIFont.systemFont(ofSize: 18.auto())
        $0.textColor = .gray
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = ""
    }

    var startTestBtn = UIButton().then() {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20.auto())

        $0.backgroundColor = mainColor
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10.auto()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.bleConnectNotify(notify:)), name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bleSystemSettingNotify(notify:)), name: NSNotification.Name.init(rawValue: SYSTEM_BLUETOOTH_STATE), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: SYSTEM_BLUETOOTH_STATE), object: nil)
        
    }
    

    override func initDisplayView() {

        messageTopLabel.text = "BloodSugarTestVC_tip".localiz()
        messageBottomLabel.text = "BloodSugarTestVC_message".localiz()

        self.title = "BloodSugarTestVC_title".localiz()
        view.backgroundColor = UIColor.white
        
        view.addSubview(messageTopLabel)
        messageTopLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(Constant.margin)
            make.right.equalTo(-Constant.margin)
            make.top.equalToSuperview().offset(navigationBarHeight + Constant.margin)
        }

        let width = (view.width * 3) / 4
        let x = (view.width - width) / 2
        let y = (view.height - width) / 2

        progressView  = BoodSugarTestProgressView.init(frame: CGRect.init(x: x, y: y, width: width, height: width))

        view.addSubview(progressView)
        view.addSubview(messageBottomLabel)
        messageBottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(Constant.margin)
            make.right.equalTo(-Constant.margin)
            make.top.equalTo(progressView.snp.bottom).offset(Constant.margin)
        }

        view.addSubview(startTestBtn)
        startTestBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(Constant.margin * 2)
            make.right.equalTo(-Constant.margin * 2)
            make.bottom.equalToSuperview().offset(-Constant.margin)
        }
        
        
        if AppDelegate.getDelegate().BloodStartTestTime == 0 {
            startTestBtn.setTitle("BloodSugarTestVC_startTest".localiz(), for: .normal)

            let model = BloodGlucoseTestDataHelp.getBloodGluresult()
            self.progressView.varLabel.text =  MydayManager.coverBloodGluModelResultValue(model)
            self.progressView.unitLabel.text = MydayManager.coverBloodGluModelDate(model)
            self.displayBloodSugarResultSuggest(model)
            self.progressView.endAnimation()
        }
        else
        {
            startTestBtn.setTitle("BloodSugarTestVC_testing".localiz(), for: .normal)
            progressView.varLabel.text = "BloodSugarTestVC_testing".localiz()
            self.progressView.startAnimation()
            self.startTestBtn.isSelected = !self.startTestBtn.isSelected
        }
    }

    fileprivate func displayBloodSugarResultSuggest(_ model: BloodSugarResultModel) {
        if model.value == "1" {
            messageBottomLabel.text = "BloodSugarTestVC_low_note".localiz()
        }else if model.value == "2" {
            messageBottomLabel.text = "BloodSugarTestVC_normal_note".localiz()
        }else if model.value == "3" {
            messageBottomLabel.text = "BloodSugarTestVC_high_note".localiz()
        }

    }

    override func initDisplayData() {

        startTestBtn.addTarget(self, action: #selector(self.startTestBtnClick), for: .touchUpInside)
        
        bledatamanage.gluReceiveCallBlock = {[unowned self] (receiveData) in
            let byteArray = receiveData.toByteArray()
            let type = GlucoseCommand.init(rawValue: UInt8(byteArray[0]))
            switch type {
            case .startRespond?:
                print("开始血糖指令返回的数据：\(receiveData)")
                AppDelegate.getDelegate().BloodStartTestTime = Int(FDDateHandleTool.timeStamp)!
                
                DispatchQueue.main.async {
                    FDLog("start Test Btn Click")
                    self.progressView.varLabel.text = "BloodSugarTestVC_testing".localiz()
                    self.startTestBtn.setTitle("BloodSugarTestVC_testing".localiz(), for: .normal)
                    if self.startTestBtn.isSelected == false {
                        self.progressView.startAnimation()
                    }
                    self.startTestBtn.isSelected = !self.startTestBtn.isSelected
                }
                break
            case .collectingRespond?:
                break
            case .timeOverRespond?:
                self.bloodGluTestFinish()
                break
            case .stopRespond?:
                self.bloodGluTestFinish()
                break
            case .glycemicResultRespond?:
                break

            default:
                break
            }
        }
        
    }

    @objc func startTestBtnClick() {
        
        
        if BleConnectState.getCurrentBleState() == false {
            AlertTool.showAlertView(message: "Myday_BLEConnect_point".localiz(), cancalTitle: "Cancel".localiz(), action: {
                print("点击了取消按钮")
            })
            return
        }
        
        if self.startTestBtn.isSelected == false {  //开始测试血糖
            
            bledatamanage.sendStartCollectGlucoseDataToDevice { (receive) in
                print("开始血糖指令返回的数据：\(receive)")
            }
        }
        else //结束测试血糖
        {
            let currentTimeStamp = Int(FDDateHandleTool.timeStamp)
            if currentTimeStamp! - AppDelegate.getDelegate().BloodStartTestTime > 30 { //超过测量时间的一半才会出一个不准确的结构

                AlertTool.showAlertView(title: "BloodSugarTestVC_point_title".localiz(), message: "BloodSugarTestVC_point_message".localiz()) { (index) in
                    if index == 0 {
                        self.bledatamanage.sendStopCollectGlucoseDataToDevice { (receive) in

                        }
                    }
                }
            }
            else
            {
                AlertTool.showAlertView(message: "BloodSugarTestVC_stop_error".localiz(), cancalTitle: "Cancel".localiz()) {
                    print("时间太短无法结束")
                }
            }
        }
    }
    
    
    func bloodGluTestFinish() {

        DispatchQueue.main.async {
            let model = BloodGlucoseTestDataHelp.getBloodGluresult()
            self.progressView.varLabel.text = MydayManager.coverBloodGluModelResultValue(model)
            self.progressView.unitLabel.text = MydayManager.coverBloodGluModelDate(model)
            self.displayBloodSugarResultSuggest(model)
            self.startTestBtn.setTitle("BloodSugarTestVC_startTest".localiz(), for: .normal)
            if self.startTestBtn.isSelected {
                self.progressView.endAnimation()
            }
            self.startTestBtn.isSelected = !self.startTestBtn.isSelected
        }

        print("结束血糖指令")
    }
    
    @objc func bleConnectNotify(notify:Notification){
        let bleState = notify.object as! NSNumber
        FDLog("ble state changed: \(bleState)")
        DispatchQueue.main.async {
            if bleState.boolValue == true {
            }
            else
            {
                self.bloodGluTestFinish()
            }
        }
    }
    
    @objc func bleSystemSettingNotify(notify:Notification){
        let bleState = notify.object as! NSNumber
        FDLog("ble state changed: \(bleState)")
        DispatchQueue.main.async {
            if bleState.boolValue == true {
            }
            else
            {
                self.bloodGluTestFinish()
            }
        }
    }

    
}
