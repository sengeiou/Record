//
//  BleOTAManager.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import CoreBluetooth
import iOSDFULibrary
import FendaBLESwiftLib

/// BLE Servereices
public enum BLEOTAServices: String {
    
    // OTA 服务对应的UUID
    case DeviceOTAServices  = "0xFE59"
    
    //    /// BLE servies uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}
/// BLE Characteristics
public enum BLEOTACharacteristics : String {
    
    
    // devict info characteristic UUID
    case deviceInfoSetting         = "4F540003-4245-4665-6E64-61536D617274"
    
    
    
    //    /// BLECharacteristics uuid
    public var uuid: CBUUID {
        return CBUUID.init(string: self.rawValue)
    }
}



enum OTA_Progress_type  {
    case OTA_SendEnter_Type
    case OTA_StartScan_Type
    case OTA_ScanTimeOut_Type
    case OTA_StartConnect_Type
    case OTA_ConnectFail_Type
    case OTA_UploadFail_Type
    case OTA_UploadSuccess_Type
    case OTA_UploadError_Type
}

class BleOTAManager: NSObject {

    //反馈升级的不同状态
    private var OTAProgressCallBackBlock: ((_ OtaType:OTA_Progress_type) -> Void)?
    private var OTAProgressBlock: ((Int) -> ())?
    var otaPeripheral    : CBPeripheral!
    private var otaController    : DFUServiceController!
    private var centralManager   : CBCentralManager!
    private var bleDataMana  = BleDataManager.instance
    private var firwarePath = ""
    
    var otaView:OtaUploadMaskView?
    
    override init() {
        super.init()
        
    }
    
    func startOTAUpgrade(firwarePath:String,OTAResultCallback:  @escaping ((OTA_Progress_type) -> Void),OTAProgressCallback: @escaping ((Int) -> Void)) {

        //操作文件，判断升级文件是否OK
        self.firwarePath = firwarePath
        
        self.OTAProgressCallBackBlock = OTAResultCallback
        self.OTAProgressBlock = OTAProgressCallback
        
        //发送进入OTA指令
        self.bleDataMana.sendStartOTAToDevice()
        //当处于OTA模式时，不需要要对原设备发起重连
        self.bleDataMana.bleOperationMana.isAutoReconnect = false
        //注册蓝牙断开通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.bleConnectNotify(notify:)), name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: nil)
        
    }
    
    
}

extension BleOTAManager {
    
    @objc func bleConnectNotify(notify:Notification) {
        let bleState = notify.object as! NSNumber

        FDLogSpecialFile("ble state changed: \(bleState)", filename: "OTALogFile")
        if bleState.boolValue == false {

            self.bleDataMana.bleOperationMana.startScabDevice(advServices: [BLEOTAServices.DeviceOTAServices.uuid], filterNameConditions: { (deviceName) -> (Bool) in
                if deviceName.hasPrefix("FD70_DFU")
                {
                    return true
                }
                return false
            }, scanedDeviceCallBlock: { (peripheralArray) in
                
                let resultArray = peripheralArray.filter({ (item) -> Bool in
                    

                    var connectedMacAddress = BleStateManager.getConnectedPeripheralMacAddress()
                    
                    print("DFU Devcie mac:\(item.macAdress)------Normal mac:\(connectedMacAddress)")

                    connectedMacAddress = connectedMacAddress.components(separatedBy: ":").last ?? "0"
                    
                    let norValue = BleOTAManager.hexTodec(number: connectedMacAddress)

                    let dfuTailStr = item.macAdress.components(separatedBy: ":").first ?? "0"
                    let dfuValue = BleOTAManager.hexTodec(number: dfuTailStr)
                    FDLog("Nor: \(connectedMacAddress): mal: \(dfuTailStr)")
                    
                    if norValue == dfuValue - 1
                    {
                        return true
                    }
                    
                    return false
                })
                if resultArray.count > 0 {
                    self.OTAProgressCallBackBlock!(.OTA_StartScan_Type)
                    self.bleDataMana.bleOperationMana.stopScanPeripherals()
                    let otaModel = resultArray.first
                    self.otaPeripheral = otaModel?.peripheral
                    self.centralManager = self.bleDataMana.bleOperationMana.centralManager
                    self.prepareStartOTAManager()
                }
            })

        }

    }
    
    
    ///
    /// - Parameter num: the original hec string
    /// - Returns: hec
    private static func hexTodec(number num:String) -> Int {
        let str = num.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48
            if i >= 65 {
                sum -= 7
            }
        }
        return sum
    }

    
    
    func prepareStartOTAManager() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            //Alvoid nil value.
            guard let _ = self.centralManager else {
                return
            }
            
            //Alvoid nil value.
            guard let _ = self.otaPeripheral else {
                return
            }
            
            // Create DFU initiator with some default configuration
            //            let dfuInitiator = DFUServiceInitiator(centralManager: self.centralManager, target: self.otaPeripheral)
            //            let ss = DFUServiceInitiator.init(target: self.otaController)
            
            let centralQueue:DispatchQueue = DispatchQueue.init(label: "com.fenda.BleOTA")
            let dfuInitiator = DFUServiceInitiator(queue: centralQueue)
            
            dfuInitiator.delegate = self
            dfuInitiator.progressDelegate = self
            dfuInitiator.logger = self
            
            
            let firmware = DFUFirmware.init(urlToZipFile: URL.init(string: self.firwarePath)!)
            
            self.otaController = dfuInitiator.with(firmware: firmware!).start(target: self.otaPeripheral)
            
        }
    }
}

extension BleOTAManager:DFUServiceDelegate,DFUProgressDelegate,LoggerDelegate {
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        FDLog(message)
        //"DFU Service not found"
        OTAProgressCallBackBlock!(.OTA_UploadError_Type)
        
    }
    func dfuStateDidChange(to state: DFUState) {
        var otaState = "OTA completed"
        
        switch state {
        case .completed:
            
            OTAProgressCallBackBlock!(.OTA_UploadSuccess_Type)
        case .aborted:
            OTAProgressCallBackBlock!(.OTA_UploadFail_Type)

            otaState = "OTA aborted"
        case .connecting:
            otaState = "connecting"
        case  .disconnecting:
            otaState = "disconnecting"
        case  .starting:
            otaState = "starting"
        case  .enablingDfuMode:
            otaState = "enablingDfuMode"
        case  .validating:

            otaState = "validating"
        case  .uploading:

            otaState = "uploading"
        }
        
        FDLogSpecialFile(otaState, filename: "OTALogFile")
    }
    
    //DFUProgressDelegate
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        //That is in main thread

        FDLogSpecialFile("\((progress))", filename: "OTALogFile")
        if self.OTAProgressBlock != nil {
            self.OTAProgressBlock!(progress)
        }
    }
    
    //LoggerDelegate
    func logWith(_ level: LogLevel, message: String) {
        
        //Is like "E: DFU Service not found"
        
        FDLogSpecialFile("\(level.name()): \(message)", filename: "OTALogFile")
        
    }
    
}

extension BleOTAManager {
    
    func startOtaInteraction() {
        let otaTimer = Timer.scheduledTimer(timeInterval: 90, target: self, selector: #selector(OtaUploadingTimerOut(timer:)), userInfo: nil, repeats: false)
        
        otaView = OtaUploadMaskView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        let localPath = getFirmwareFilePath()
        FDLog("localPath:\(localPath)")
        startOTAUpgrade(firwarePath: localPath, OTAResultCallback: { (OTAType) in
            print(OTAType)

            DispatchQueue.main.async {
                switch OTAType {
                case .OTA_StartScan_Type:
                    FDLog("OTA_StartScan_Type:")
                    AppDelegate.getDelegate().window!.addSubview(self.otaView!)
                    break
                case .OTA_UploadSuccess_Type:
                     FDLog("OTA_UploadSuccess_Type")
                    otaTimer.invalidate()
                    self.otaView!.changeOtaViewDisplay(state: .OTAState_success)
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        self.otaView?.removeFromSuperview()
                        //升级成功之后发起重连
                        
                        BleConnectState.BleReconnectHandle(timeouthandle: {
                            print("OTA完成后，重连超时")
                        })
                    })
                    
                    break
                case .OTA_UploadFail_Type:
                     FDLog("OTA_UploadFail_Type")
                    otaTimer.invalidate()
                    self.otaView!.changeOtaViewDisplay(state: .OTAState_Failure)
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        self.otaView?.removeFromSuperview()
                    })
                    break
                default:
                    break
                }
            }
            
        }, OTAProgressCallback: { (progress) in
            DispatchQueue.main.async {
                print(progress)
                self.otaView!.changeOTaProgress(progress: progress)
            }
            
        })
    }
    
    @objc func OtaUploadingTimerOut(timer:Timer) {
        timer.invalidate()
        self.otaView!.changeOtaViewDisplay(state: .OTAState_Failure)
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.otaView?.removeFromSuperview()
        })
        
    }
    
}
extension BleOTAManager {
    func getFirmwareFilePath() ->String {

        let boundlePath = Bundle.main.path(forResource: "2019_0506_1654_FD070_00.00.16.190506_beta", ofType: "zip")!

        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        let firmwarePackageDirectory = documentsDirectory + "/FirmwarePackage"
        let fileManager = FileManager.default
        if let files = try? fileManager.contentsOfDirectory(atPath: firmwarePackageDirectory)  {
            guard let file = files.sorted().last else {
                return boundlePath
            }

            return  firmwarePackageDirectory + "/" + file
        }else {
            return boundlePath
        }

    }
}

