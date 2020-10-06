//
//  BleOperatorManager.swift
//  BLESwiftModule
//
//  Created by WANG DONG on 2017/7/25.
//  Copyright © 2017年 WANG DONG. All rights reserved.
//

import UIKit
import CoreBluetooth

public typealias scanedPeripheralaBlock = (_ peripheralsModelArray : [BlePeripheralModel]) -> ()

public typealias realTimeUpdateDeviceOriginalBlock = (_ peripheral : CBPeripheral,_ advertisementData : NSDictionary,_ RSSI : NSNumber) -> ()

public typealias bindCallBackBlock = () -> ()

/// 该闭包回调的是打印信息,方便在界面上进行日志显示,如果只需要将LOG信息在控制台显示,无须该回调
public typealias logBlock = (_ logStr:String) -> ()

/// 连接成功之后执行的初始化操作
public typealias connectedDeviceAfterInitCommunicatStream = () -> ()

/// 搜索时候需要过滤的条件。
public typealias filterDeviceNameConditions = (_ conditions:String) -> (Bool)

/// Block 返回需要resore的蓝牙设备。
public typealias bleWillRestorePeripheral = (_ PeripheralDict:[Any]) -> ()
//限定该delegate只能有class来实现

public protocol bleOperationDelegate:class{
    
    /// 返回接收到的数据
    ///
    /// - Parameters:
    ///   - data: 接收到的原始数据
    ///   - characteristic: 对应的特性
    /// - Returns: 返回空置
    func didReceiveDataFromBand(data : Data , characteristic : CBCharacteristic) -> Void
    
    
    /// 实现代理使能对应的通知
    ///
    /// - Parameter characteristic: 传出对应的特性
    /// - Returns: 无返回值
    func enableSpecialCharacteristicsaNotify(characteristic:CBCharacteristic) ->Void
    
}


open class BleOperatorManager: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    public var centralManager:CBCentralManager!
    
    private var peripheralsArray:Array = [BlePeripheralModel]()
    private var peripheralServiceCharacteristicDic:NSMutableDictionary = NSMutableDictionary.init()
    
    public var isAutoReconnect:Bool! //区分是否需要自动连接
    public var ownPeripheral:CBPeripheral!
    
    public var centralQueue:DispatchQueue!
    
    /// 通过该delegate属性建立起委托关系
    public weak var delegate:bleOperationDelegate?
    public var scanedDevicesBlockProperty : scanedPeripheralaBlock?
    
    public var realTimeUpdateScanOriginalBlock : realTimeUpdateDeviceOriginalBlock?
    
    public var bindDeviceCallBackBlock : bindCallBackBlock?
    /// 该闭包回调的是打印信息,方便在界面上进行日志显示,如果只需要将LOG信息在控制台显示,无须该回调
    public var logBlockProperty : logBlock?

    public var connectedDeviceAfterInitCommunicatStream:connectedDeviceAfterInitCommunicatStream?
    public var bleWillRestorePeripheralBlock:bleWillRestorePeripheral?
    fileprivate var filterDeviceName:String?
    public var filterDeviceNameConditionsAction:filterDeviceNameConditions?

    public static let instance = BleOperatorManager()
    private override init() {
        super.init()
        self.initCentralDevice()
    }

    func initCentralDevice() {
        
        isAutoReconnect = true
        let options:Dictionary = [
            CBCentralManagerOptionRestoreIdentifierKey:"myCentralManagerIdentifier",
            CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true)
        ] as [String : Any]
        
       centralQueue = DispatchQueue.init(label: "com.fenda.BleCentral")
        
        centralManager = CBCentralManager.init(delegate: self, queue: centralQueue, options: options)
        UserDefaults.standard.set(false, forKey: BLECONNECTSTATE)
        UserDefaults.standard.synchronize()
    }
    
    
    /// 开始搜索设备
    ///
    /// - Parameters:
    ///   - advServices: 指定的服务
    ///   - filterNameConditions: 搜索的过滤调教
    ///   - scanedDeviceCallBlock: 搜索到的设备
    public func startScabDevice(advServices:Array<Any>,filterNameConditions:filterDeviceNameConditions?,scanedDeviceCallBlock:scanedPeripheralaBlock?) {
        
        if filterNameConditions != nil {
            self.filterDeviceNameConditionsAction = filterNameConditions
        }
        
        if scanedDeviceCallBlock != nil {
            self.scanedDevicesBlockProperty = scanedDeviceCallBlock
        }
        
        let clearCache = {
            
            self.peripheralsArray.removeAll()
            self.peripheralServiceCharacteristicDic.removeAllObjects()
        }

        //避免从新搜索是引起线程冲突
        centralQueue.asyncAfter(deadline: .now()+0.5) {
            clearCache()
            self.scanPeripherals(serviceUUIDs: advServices as! [CBUUID])
        }
    }
    
    private func scanPeripherals(serviceUUIDs : [CBUUID]) {
        
        if centralManager.state == .poweredOn {
            if serviceUUIDs.isEmpty {
                centralManager.scanForPeripherals(withServices: [], options: [
                    CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber.init(booleanLiteral: true)
                    ])
                print("Scan all discovered peripherals")
            }
            else
            {
                let retrieveDeviceArray:Array = centralManager.retrieveConnectedPeripherals(withServices: serviceUUIDs)
                if retrieveDeviceArray.isEmpty
                {
                    centralManager.scanForPeripherals(withServices: serviceUUIDs,options:[
                        CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber.init(booleanLiteral: true)
                        ]);
                }
                else
                {
                    ownPeripheral = retrieveDeviceArray.first
                    connectSelectPeripheral(peripheral: ownPeripheral)
                    print("Try reconnecting Device")
                }

            }
        }
        else
        {
            print("Please Open Bluetooth")
        }
    }

    public func connectSelectPeripheral(peripheral : CBPeripheral)
    {
        ownPeripheral = peripheral
        ownPeripheral.delegate = self
        centralManager.connect(peripheral, options: [
            CBConnectPeripheralOptionNotifyOnConnectionKey:NSNumber.init(value: true),
            CBConnectPeripheralOptionNotifyOnDisconnectionKey:NSNumber.init(value: true),
            CBConnectPeripheralOptionNotifyOnNotificationKey:NSNumber.init(value: true)])
    }
    
    public func removeBindDevice() {
        
        UserDefaults.standard.set(false, forKey: BLERECONNECTACTION)
        UserDefaults.standard.removeObject(forKey: BLEConnectedPeripheralUUID)
        UserDefaults.standard.removeObject(forKey: BLEBANDMACADDRESS)
        UserDefaults.standard.synchronize()
        self.isAutoReconnect = false

        if ownPeripheral != nil {
            centralManager.cancelPeripheralConnection(self.ownPeripheral);
        }
    }
    
   public func delegateRedirect(cbCentral:CBCentralManager) {
        self.centralManager = cbCentral
        self.centralManager.delegate = self
    }
    
    public func disConnectCertainPeripheral(isAutoReconnect:Bool)
    {
        self.isAutoReconnect = isAutoReconnect
        if ownPeripheral != nil {
            UserDefaults.standard.set(false, forKey: BLERECONNECTACTION)
            UserDefaults.standard.synchronize()
            centralManager.cancelPeripheralConnection(self.ownPeripheral);
        }
    }
    
    public func stopScanPeripherals()
    {
        centralManager.stopScan();
    }
    
    public func reconnectPeripheral()
    {
        if isAutoReconnect == false {
            return
        }

        if let peripheralUUID = UserDefaults.standard.string(forKey:BLEConnectedPeripheralUUID) as String? {
            let arr = centralManager.retrievePeripherals(withIdentifiers: [NSUUID.init(uuidString: peripheralUUID)! as UUID])
            if arr.count > 0 {
                
                if self.bleWillRestorePeripheralBlock != nil {
                    self.bleWillRestorePeripheralBlock!(arr)
                }

                let peripheral:CBPeripheral = arr.first!
                switch peripheral.state
                {
                    case .disconnected,.connecting:
                        self.connectSelectPeripheral(peripheral: peripheral)
                        print("Start Reconnect Device")
                    case .connected:
                        startDiscoverServices(peripheral: peripheral)
                        print("Start Discover Service")
                    case .disconnecting:
                        centralManager.cancelPeripheralConnection(peripheral);
                        print("Device disconnecting")
                }
                
                return
            }
            print("No device retrieve");
            
        } else {
            print("未连接过任何设备,无法发起重连")
        }
    }
    
    
    func startDiscoverServices(peripheral:CBPeripheral) {
        ownPeripheral = peripheral
        ownPeripheral.delegate = self
        ownPeripheral.discoverServices(nil)
        peripheralServiceCharacteristicDic = NSMutableDictionary.init()
    }
    
    
    // MARK:从APP端发送数据给外设
    public func sendDataFromAppToBand(data : Data , serviceUUIDString : String , characteristicString : String , writeType : CBCharacteristicWriteType) -> Void {

        let containsService = peripheralServiceCharacteristicDic.allKeys.contains { return $0 as? String == serviceUUIDString }
        if containsService {
            
            let characterDic:NSDictionary = peripheralServiceCharacteristicDic.object(forKey: serviceUUIDString) as! NSDictionary
            
            let containsKey = characterDic.allKeys.contains { return $0 as? String == characteristicString }
            if containsKey {
                
                let sendDataModel:BleCharacterModel = characterDic.object(forKey: characteristicString) as! BleCharacterModel
                
                ownPeripheral.writeValue(data, for:sendDataModel.bleCharacteristic , type: CBCharacteristicWriteType(rawValue: CBCharacteristicWriteType.RawValue(sendDataModel.bleCharacteristic.properties.rawValue))!)
                
            }
        }
    }
    
    /**
     *  APP主动读取数据
     *
     *  @param serviceUUID        服务的UUID
     *  @param characteristicUUID 特性的UUID
     */
    public func readDataFromBand(serviceUUIDString : String , characteristicString : String) {
        let containService = peripheralServiceCharacteristicDic.allKeys.contains{
            return $0 as? String == serviceUUIDString }
        if containService {
            
            let characterDic:NSDictionary = peripheralServiceCharacteristicDic.object(forKey: serviceUUIDString) as! NSDictionary
            let containskey = characterDic.allKeys.contains{
                return $0 as? String == characteristicString}
            if containskey {
                let readDataModel:BleCharacterModel = characterDic.object(forKey: characteristicString) as! BleCharacterModel
                ownPeripheral.readValue(for: readDataModel.bleCharacteristic)
            }
            
        }
        
    }
    /**
     *  设置通知使能
     *
     *  @param isEnable           使能开关
     *  @param serviceUUID        服务的UUID
     *  @param characteristicUUID 特性的UUID
     */
    public func setNotifyEnableWith(isEnable:Bool,serviceUUIDString : String , characteristicString : String) {
        let containService = peripheralServiceCharacteristicDic.allKeys.contains{
            return $0 as? String == serviceUUIDString }
        if containService {
            
            let characterDic:NSDictionary = peripheralServiceCharacteristicDic.object(forKey: serviceUUIDString) as! NSDictionary
            let containskey = characterDic.allKeys.contains{
                return $0 as? String == characteristicString}
            if containskey {
                
                let notifyDataModel:BleCharacterModel = characterDic.object(forKey: characteristicString) as! BleCharacterModel
                print("Enable Notify:\(characteristicString)")
                ownPeripheral.setNotifyValue(isEnable, for: notifyDataModel.bleCharacteristic)
            }
            
        }
        
    }

    // MARK:持久化相关字段，彻底断开蓝牙时需要清除重连标示以及Mac地址
    
   public func saveOrRemoveRalated(isSave:Bool) {
        if isSave == true {
            
            UserDefaults.standard.set(true, forKey: BLECONNECTSTATE)

            UserDefaults.standard.set(self.ownPeripheral.identifier.uuidString, forKey: BLEConnectedPeripheralUUID)

            if UserDefaults.standard.string(forKey: BLEBANDMACADDRESS) == nil {

                let resultPeripheral = self.peripheralsArray.filter { (item) -> Bool in
                    return item.peripheral.identifier.uuidString == self.ownPeripheral.identifier.uuidString
                }
                if resultPeripheral.count > 0 {
                     UserDefaults.standard.set(resultPeripheral.first?.macAdress, forKey: BLEBANDMACADDRESS)
                }
            }
            UserDefaults.standard.synchronize()
            
            //Initialization Setting after successful connection
            if self.connectedDeviceAfterInitCommunicatStream != nil
            {
                self.connectedDeviceAfterInitCommunicatStream!()
            }
            
        }
        else {
            //Disconnect and remove UserDefaults
            UserDefaults.standard.set(false, forKey: BLECONNECTSTATE)
            UserDefaults.standard.synchronize()
        }
    }


    // MARK:判断设备当前蓝牙状态
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
            
        case .resetting:
            print("resetting")
            
        case .unsupported:
            print("unsupported")
            
        case .unauthorized:
            print("unauthorized")
            
        case .poweredOff:
            print("poweredOff")
            if self.logBlockProperty != nil {
                self.logBlockProperty?("The Bluetooth is poweredOff")
            }
            //所有连接断开的系统方法都只有在蓝牙处于打开状态时，才可以使用。
            self.disConnectCertainPeripheral(isAutoReconnect: true)
            //IOS 11.0以上的系统关闭蓝牙不会回调断开连接的回调

//            if #available(iOS 11.0, *){
                DispatchQueue.main.async(execute: { () -> Void in
                    self.saveOrRemoveRalated(isSave: false)
                })
//            }

            //持久化蓝牙开关状态
            UserDefaults.standard.set(false, forKey: SYSTEM_BLUETOOTH_STATE)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SYSTEM_BLUETOOTH_STATE), object: NSNumber.init(booleanLiteral: false))
            
        case .poweredOn:
            print("poweredOn11111111111111")
            if self.logBlockProperty != nil {
                self.logBlockProperty?("The Bluetooth is poweredOn")
            }
            //持久化蓝牙开关状态
            UserDefaults.standard.set(true, forKey: SYSTEM_BLUETOOTH_STATE)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SYSTEM_BLUETOOTH_STATE), object: NSNumber.init(booleanLiteral: true))
        }
    }

    // MARK:搜索到外设
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if RSSI != 127 {
            
//            print(advertisementData)
            
            // Real Time return original Data
            if self.realTimeUpdateScanOriginalBlock != nil{
                self.realTimeUpdateScanOriginalBlock?(peripheral,advertisementData as NSDictionary,RSSI)
            }

            guard self.filterDeviceNameConditionsAction == nil else{
                
                if let deviceName:String = advertisementData[KCBADV_DATALOCAL_NAME] as? String{
                    if self.filterDeviceNameConditionsAction!(deviceName){
                        
                        if (self.scanedDevicesBlockProperty != nil) {
                            
                            self.peripheralsArray = BleSingleton.instance.handleBleAdvertisementData(peripheralArray: self.peripheralsArray, advertisementData: advertisementData as NSDictionary, peripheral: peripheral, RSSI: RSSI)
                            self.scanedDevicesBlockProperty?(BleSingleton.instance.rankPeripheralArrayWithRSSI( peripheralsArray: self.peripheralsArray))

                        }

                    }
                }
                return
            }
            if (self.scanedDevicesBlockProperty != nil) {
                self.peripheralsArray = BleSingleton.instance.handleBleAdvertisementData(peripheralArray: self.peripheralsArray, advertisementData: advertisementData as NSDictionary, peripheral: peripheral, RSSI: RSSI)
                self.scanedDevicesBlockProperty?(BleSingleton.instance.rankPeripheralArrayWithRSSI(peripheralsArray: self.peripheralsArray ))
            }
            
            // Real Time return original Data
//            if self.realTimeUpdateScanOriginalBlock != nil{
//                self.realTimeUpdateScanOriginalBlock?(peripheral,advertisementData as NSDictionary,RSSI)
//            }
        }
    }
    
    
    // MARK:与外设建立连接
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        startDiscoverServices(peripheral: peripheral)
        print("didConnectPeripheral")
        
    }
    
    
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {

        if let deviceDict:[String : Any] = dict {
            if self.bleWillRestorePeripheralBlock != nil && deviceDict.keys.contains("kCBRestoredPeripherals") {
                self.bleWillRestorePeripheralBlock!(deviceDict["kCBRestoredPeripherals"] as! [Any])
            }
        }
        print("centralManager.willRestoreState", dict)
    }
    
    // MARK:连接外设失败
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if self.logBlockProperty != nil {
            self.logBlockProperty?("didFailToConnectPeripheral")
        }
    }
    
    
    // MARK:与外设失去连接
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        //修改蓝牙连接状态
        print("didDisconnectPeripheral")
        print(error?.localizedDescription ?? "断连无错误原因")
        
        if self.logBlockProperty != nil {
            if let errorStr = error?.localizedDescription {
                self.logBlockProperty?(NSString.init(format: "didDisconnectPeripheral:%@", errorStr) as String)
                } else {
                self.logBlockProperty?("didDisconnectPeripheral")
            }
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.saveOrRemoveRalated(isSave: false)
            
            print("\(NSNotification.Name.init(rawValue: BLECONNECTSTATE))---\(NSNumber.init(booleanLiteral: false))")
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: NSNumber.init(booleanLiteral: false))
            
        })
    }
    
    
    // MARK:发现服务的回调
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        
        if error != nil {
            print("Discover Services failed:\(String(describing: error))")
            return
        }
        
        
        for service in peripheral.services! {
            
//            print("Discover Services-->\(service.uuid.uuidString)")
            peripheral.discoverCharacteristics([], for: service)

        }
        print("didDiscoverServices")
        if self.logBlockProperty != nil {
            self.logBlockProperty?("didDiscoverServices")
        }
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.saveOrRemoveRalated(isSave: true)
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue:BLECONNECTSTATE), object: NSNumber.init(booleanLiteral: true))
        }
    }

    // MARK:发现服务的特性的回调
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {
            print("Discover Characteristics failed:\(String(describing: error))")
            return
        }
        
        let charaterDic = NSMutableDictionary.init()
        
        if let charaArray = service.characteristics as [CBCharacteristic]? {
            for characteristic in charaArray {
//                 print("Discover characteristic-->\(characteristic.uuid.uuidString)")
                if self.delegate != nil
                {
                    self.delegate?.enableSpecialCharacteristicsaNotify(characteristic: characteristic)
                }

                let bleCharaModel:BleCharacterModel = BleCharacterModel()
                bleCharaModel.bleCharacteristic = characteristic
                bleCharaModel.characteristicProperties = characteristic.properties
                charaterDic.setObject(bleCharaModel, forKey: characteristic.uuid.uuidString as NSCopying)
            }
        }
        peripheralServiceCharacteristicDic.setObject(charaterDic, forKey: service.uuid.uuidString as NSCopying)
    }
    
    
    // MARK:外设更新值
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            print("Update Value failed:\(String(describing: error))")
            return
        }
        

        if let validValue:Data = characteristic.value as Data? {
            
//            print(String.init(format: "%@", validValue as CVarArg))

            if self.logBlockProperty != nil {
                self.logBlockProperty!(String.init(format: "%@", validValue as CVarArg))
            }
            
            if self.delegate != nil
            {
                 self.delegate?.didReceiveDataFromBand(data: validValue, characteristic: characteristic)
            }
        }
    }
    
    
    // MARK:向外设发送数据后的回调
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(error ?? "data send successfully");
    }
    
}
