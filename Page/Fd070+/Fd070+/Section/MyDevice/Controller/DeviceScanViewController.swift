//
//  DeviceScanViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/18.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib

class DeviceScanViewController: BaseViewController {

    var deviceScanView:DevcieScanIngVeiw = DevcieScanIngVeiw()
    
    fileprivate let bleDataMana = BleDataManager.instance
    
    
    fileprivate var scanDevceiArray:[BlePeripheralModel]?
    
    fileprivate var refreshTableTimer:Timer?
    
    fileprivate var currentPeripheralModel:BlePeripheralModel?
    
    fileprivate var currentType:DeviceScaningState?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "DeviceSearchVC_title".localiz()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: nil)
    }
    
    override func initDisplayData() {

        NotificationCenter.default.addObserver(self, selector: #selector(self.bleConnectNotify(notify:)), name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bleSystemBluetoothState(notify:)), name: NSNotification.Name.init(rawValue: SYSTEM_BLUETOOTH_STATE), object: nil)

        
        startScanDevice()

    }
    
    override func initDisplayView() {
        
        self.view.addSubview(deviceScanView)

        deviceScanView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view).offset(navigationBarHeight)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
            } else {
                maker.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).inset(15)
            }
            maker.left.right.equalTo(view)
        }

        deviceScanView.didSelctCell = {[unowned self] (peripheralModel) in
            self.deviceScanView.changeViewDisplay(type: .Device_Scaned_State)
            self.deviceScanView.changeViewDisplay(type: .Device_ScanConnectting_State)
            self.currentPeripheralModel = peripheralModel
            
            self.bleDataMana.bleOperationMana.connectSelectPeripheral(peripheral: peripheralModel.peripheral)
            //复用定时器，需要先销毁定时器，然后在重新复用
            self.DestructionTimer()
            self.refreshTableTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.connectDeviceTimerOut), userInfo: nil, repeats: false)
            self.currentType = .Device_ScanConnectting_State
        }
        
        deviceScanView.didCleckBtn = { [unowned self](tag) in
            
            switch tag {
            case DeviceScaningTag.tag_BtnCancel.code:
                self.stopScanDevice()
                break
            case DeviceScaningTag.tag_BtnRescan.code:
                if BleConnectState.getSystemBleState() == false {
                    AlertTool.showAlertView(message: "TurnOnSystemBluetooth".localiz(), cancalTitle: "Cancel".localiz(), action: {
                        print("点击了取消按钮")
                    })
                    return
                }
                self.deviceScanView.changeViewDisplay(type: .Device_StartScan_State)
                self.startScanDevice()
                break
            case DeviceScaningTag.tag_BtnRightNowStart.code:
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.changeRootViewController()

                /// 连接成功，插入设备信息。
                let deviceInfoModel = DeviceInfoModel.init(userid: CurrentUserID, bt_mac: CurrentMacAddress, isupload: "0", device_name: (self.currentPeripheralModel?.deviceName)!, device_id: DeviceInfoType.Device_FD070Plus.rawValue, customary_unit: "", customary_hand: "", hr_test_switch: "", automatic_sync: "", band_version: CurrentBandVersion, app_version: "", dial_style: "")

                try? DeviceInfoDataHelper.insertOrUpdate(items: [deviceInfoModel], complete: {
                    DeviceManager.uploadNotUpdateDeviceInformation()
                })

                self.bleDataMana.currentHandleDeviceModel = deviceInfoModel

                break
            default:
                break
            }
        }

    }
    
    
    /// 开始搜索设备
    func startScanDevice() {
        
        self.currentType = .Device_StartScan_State
        self.scanDevceiArray = nil
        self.DestructionTimer()
        //每一秒刷新一次搜索列表
        self.refreshTableTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerHandle), userInfo: nil, repeats: true)
        
        self.bleDataMana.bleOperationMana.startScabDevice(advServices: [], filterNameConditions: { (deviceName) -> (Bool) in
            if deviceName.hasPrefix("FD70")
            {
                return true
            }
            
            return false
        }, scanedDeviceCallBlock: { [unowned self](peripheralArray) in
            self.scanDevceiArray = peripheralArray
        })
        
        //5秒之后停止搜索设备
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.stopScanDevice()
        }
    }
    
    
    /// 结束搜索设备
    func stopScanDevice() {
        
        self.DestructionTimer()
        
        self.bleDataMana.bleOperationMana.stopScanPeripherals()
        
        if self.scanDevceiArray != nil {
            
            self.currentType = .Device_Scaned_State
            self.deviceScanView.changeViewDisplay(type: .Device_Scaned_State)
            self.deviceScanView.deviceScanmodelArray = self.scanDevceiArray
        }
        else
        {
            self.currentType = .Device_ScanFaild_State
            self.deviceScanView.changeViewDisplay(type: .Device_ScanFaild_State)
            print("搜索失败")
        }
    }
    
    
    
    @objc func bleConnectNotify(notify:Notification) {

        let bleState = notify.object as! NSNumber
        FDLog("ble state changed: \(bleState)")
        
        DispatchQueue.main.async {
            
            //不管连接成功，还是连接失败，需要先销毁定时器
            self.DestructionTimer()
            
            if bleState.boolValue == true {
                //TODO: 临时去掉配对框功能,直接显示成功
//                self.deviceScanView.changeViewDisplay(type: .Device_ConnectPairSuccess_State)
                //发送握手协议，需要在设备端确认
                self.deviceScanView.changeViewDisplay(type: .Device_ScanConnectSucces_State)
                self.currentType = .Device_ScanConnectSucces_State
                //若20秒不响应消息则提示连接失败
                self.refreshTableTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.noRespondsAck), userInfo: nil, repeats: true)
                
                self.bleDataMana.sendOpenPairWindowToDevice({[unowned self] (reseiveData) in
                    
                    DispatchQueue.main.async {

                        let byteArray = reseiveData.toByteArray()
                        let type = DeviceSettingCommand.init(rawValue: byteArray[0])
                        
                        if type == .Header_OpenPairWindow{
                            //回复消息之后马上撤销定时器
                            self.DestructionTimer()
                            self.currentType = .Device_ConnectPairSuccess_State
                            self.deviceScanView.changeViewDisplay(type: .Device_ConnectPairSuccess_State)
                        }
                    }
                })
                
            }
            else
            {
                self.currentType = .Device_ScanConnectFaild_State
                self.deviceScanView.changeViewDisplay(type: .Device_ScanConnectFaild_State)
            }
        }

    }
    
    
    @objc func bleSystemBluetoothState(notify:Notification) {
        let bleState = notify.object as! NSNumber
        FDLog("ble state changed: \(bleState)")
        DispatchQueue.main.async {
            if bleState.boolValue == true {
                
            }
            else
            {
                self.connectDeviceTimerOut()
                switch self.currentType {
                case .Device_StartScan_State?,.Device_Scaned_State?:
                    self.deviceScanView.changeViewDisplay(type: .Device_ScanFaild_State)
                    break
                case .Device_ScanConnectting_State?,.Device_ScanConnectSucces_State?:
                    self.noRespondsAck()
                    break
                default:
//                    self.deviceScanView.changeViewDisplay(type: .Device_ScanFaild_State)
                    break

                }
                
        
            }
        }
    }

}


// MARK: - 定时操作
extension DeviceScanViewController {
    /// 定时器定时操作
    @objc func timerHandle() {
        
        if self.scanDevceiArray != nil {
            self.deviceScanView.deviceScanmodelArray = self.scanDevceiArray
        }
    }
    
    
    /// 超时没有连接成功，则需要移除所有连接相关的参数
    @objc func connectDeviceTimerOut() {
        DestructionTimer()
        self.bleDataMana.bleOperationMana.removeBindDevice()
        
    }
    //当发送握手协议之后，若在20秒之内没有应答之后，则销毁定时器的同时显示连接失败
      @objc func noRespondsAck() {
        DestructionTimer()
        self.bleDataMana.bleOperationMana.removeBindDevice()
        self.currentType = .Device_ScanConnectFaild_State
        self.deviceScanView.changeViewDisplay(type: .Device_ScanConnectFaild_State)
    }
    
    /// 销毁定时器
    func DestructionTimer() {
        if self.refreshTableTimer != nil {
            self.refreshTableTimer?.invalidate()
            self.refreshTableTimer = nil
        }
    }
}
