//
//  DevcieScanIngVeiw.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/18.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib
import CoreBluetooth
import NVActivityIndicatorView

public enum DeviceScaningState:Int {
    
    case Device_StartScan_State = 0
    
    case Device_Scaned_State
    
    case Device_ScanFaild_State
    
    case Device_ScanConnectting_State
    
    case Device_ScanConnectSucces_State
    
    case Device_ScanConnectFaild_State
    
    case Device_ConnectPairSuccess_State
    
    case Device_ConnectPairFaild_State
}


public enum DeviceScaningTag:Int {
    
    case tag_BtnCancel = 1000
    
    case tag_BtnRescan = 1001
    
    case tag_BtnRightNowStart = 1002
    
    case tag_BtnNoNeed = 1003
    
    var code: Int {
        return rawValue
    }
}


public typealias didSelectDeviceCellBlock = (_ peripheralModel:BlePeripheralModel) -> ()
public typealias didClickScanBtnBlock = (_ tagheral:Int) -> ()


class DevcieScanIngVeiw: UIView,UITableViewDelegate,UITableViewDataSource {

    public var didSelctCell : didSelectDeviceCellBlock?
    public var didCleckBtn : didClickScanBtnBlock?
    
    let deviceListTable: UITableView =  UITableView()
    let scanFailLabel: UILabel =  UILabel()
    let cancelScanBtn = GeneralButton(frame: CGRect.zero, generalBtnTitle: "Cancel".localiz() as NSString)
    
    //搜索设备时的动画
    var scanImageAnima:UIImageView = UIImageView()
    
    
    /// 显示搜索失败或者正在连接
    var bgDisplayView:UIView = UIView()
    
    //失败之后的View置顶
    var bgConnectFailView:UIView = UIView()
    
    // 显示连接成功之后需要在手环上敲击的引动画面
    var bgMaskView:UIView = UIView()
    
    //敲击之后，显示配对成功或者失败
    var bgPairView:UIView = UIView()
    
    
    var activityView = NVActivityIndicatorView.init(frame: CGRect.zero)
    
    public var deviceScanmodelArray:[BlePeripheralModel]? {
        
        didSet{
            
            self.deviceListTable.reloadData()
            print("设置对应的值")
            
        }
    
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initDisplayData()
        self.initDisplayView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initDisplayData () {
        
    }
    
    func initDisplayView () {
        
        let imageView:UIImageView = UIImageView(image: UIImage.init(named: "Scan_device"))
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(20)
            maker.centerX.equalTo(self)
            maker.width.equalTo(65)
            maker.height.equalTo(162)
        }
        
        let lineLayer:CALayer = CALayer()
        lineLayer.frame = CGRect(x: 20, y: imageView.frame.maxY+28, width: SCREEN_WIDTH-40, height: 0.5)
        lineLayer.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(lineLayer)

        
        self.addSubview(self.bgMaskView)
        bgMaskView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bgMaskView.isHidden = true
        bgMaskView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(-navigationBarHeight)
            maker.bottom.left.right.equalTo(self)
        }
        
        self.creactConnectSuccessView()

        cancelScanBtn.generalBtnAction = {
            if self.didCleckBtn != nil {
                self.didCleckBtn!(self.cancelScanBtn.tag)
            }
        }

        cancelScanBtn.tag = DeviceScaningTag.tag_BtnCancel.rawValue
        self.addSubview(cancelScanBtn)

        cancelScanBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.snp.bottom).offset(-30)
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-20)
            maker.height.equalTo(50)
        }

        self.addSubview(self.deviceListTable)


        deviceListTable.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(10)
            maker.left.right.equalTo(self)
            maker.bottom.equalTo(cancelScanBtn.snp.top).offset(-20)
        }
        
        deviceListTable.backgroundColor = .white
        deviceListTable.dataSource=self
        deviceListTable.delegate=self
        deviceListTable.tableFooterView=UIView()
        
        self.addSubview(bgDisplayView)
        bgDisplayView.backgroundColor = UIColor.white
        bgDisplayView.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(10)
            maker.left.right.equalTo(self)
            maker.bottom.equalTo(cancelScanBtn.snp.top).offset(-20)
        }
        
        self.addSubview(bgConnectFailView)
        bgConnectFailView.backgroundColor = UIColor.white
        bgConnectFailView.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(10)
            maker.left.right.equalTo(self)
            maker.bottom.equalTo(cancelScanBtn.snp.top).offset(-20)
        }
        //创建连接失败的View
        self.creatConnectFailView()
        

        bgDisplayView.addSubview(scanFailLabel)
        scanFailLabel.isHidden = true
        scanFailLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(40)
            maker.right.equalTo(self).offset(-40)
            maker.top.equalTo(bgDisplayView)
        }
        scanFailLabel.textAlignment = .left
        scanFailLabel.font = UIFont.systemFont(ofSize: 16)
        scanFailLabel.textColor = .black
        scanFailLabel.numberOfLines = 0
        let text = "DeviceSearchVC_noDevice_warning".localiz()
        let attributedString = NSMutableAttributedString(string: text)
        let range = attributedString.string.range(of: "DeviceSearchVC_tip".localiz())
        let nsrange = attributedString.string.nsRange(from: range!)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15.auto()), range: nsrange!)
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10 //大小调整
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        scanFailLabel.attributedText = attributedString

        self.addSubview(self.bgPairView)
        bgPairView.backgroundColor = UIColor.white
        bgPairView.isHidden = true
        bgPairView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(-navigationBarHeight)
            maker.top.bottom.left.right.equalTo(self)
        }
        
        self.crectPairResultView(type: .Device_ConnectPairSuccess_State)
        
        self.scanImageAnima = UIImageView(image: UIImage.init(named: "Bluetooth_search"))
        self.addSubview(scanImageAnima)
        
        self.scanImageAnima.snp.makeConstraints { (Maker) in
            Maker.top.equalTo(imageView.snp.bottom).offset(-60)
            Maker.centerX.equalTo(self).offset(30)
        }
        
        self.bringSubview(toFront: deviceListTable)
        
        startScanAnimation()

    }
    
    
    
    
    /// 根据不同的状态来区分UI的显示
    ///
    /// - Parameter type: 连接蓝牙的过程中不同的状态
    public func changeViewDisplay(type:DeviceScaningState) {
        switch type {
        case .Device_StartScan_State:
            self.deviceScanmodelArray = nil
            self.deviceListTable.reloadData()
            self.bringSubview(toFront: deviceListTable)
            self.cancelScanBtn.tag = DeviceScaningTag.tag_BtnCancel.rawValue
             self.cancelScanBtn.setTitle("Cancel".localiz(), for: .normal)
            self.startScanAnimation()
            break
        case .Device_Scaned_State:
            
            self.cancelScanBtn.tag = DeviceScaningTag.tag_BtnRescan.rawValue
            self.cancelScanBtn.setTitle("DeviceSearchVC_reSearch".localiz(), for: .normal)
            
            self.stopScanAnimation()
            break
        case .Device_ScanFaild_State:
            self.stopScanAnimation()
            self.cancelScanBtn.tag = DeviceScaningTag.tag_BtnRescan.rawValue
            self.cancelScanBtn.setTitle("DeviceSearchVC_reSearch".localiz(), for: .normal)
            self.scanFailLabel.isHidden = false
            self.bringSubview(toFront: self.bgDisplayView)
            break
        case .Device_ScanConnectting_State:
            self.deviceConnectingDevice()
            break
        case .Device_ScanConnectSucces_State:
            self.deviceConnectSuccess()
            break
        case .Device_ScanConnectFaild_State:
            self.deviceConnectFail()
            break
            
        case .Device_ConnectPairSuccess_State,.Device_ConnectPairFaild_State:
            self.devicePairResult(type: type)
            break
        }
    }
    
    
    
    /// 开始搜索蓝牙动画
    func startScanAnimation() {

        let boundingRect = CGRect(x:SCREEN_WIDTH/2-5, y:navigationBarHeight, width:50, height:50)
        
        let orbit = CAKeyframeAnimation(keyPath:"position")
        orbit.duration = 1.3
        orbit.path = CGPath(ellipseIn: boundingRect, transform: nil)
        orbit.calculationMode = kCAAnimationPaced
        orbit.repeatCount = HUGE
        orbit.isRemovedOnCompletion = false
        orbit.fillMode = kCAFillModeForwards
        self.scanImageAnima.layer.add(orbit, forKey:"Move")
        self.bgPairView.isHidden = true
        bgMaskView.isHidden = true
        
    }
    
    
    /// 停止搜索设备
    func stopScanAnimation() {
        self.scanImageAnima.layer.removeAllAnimations()
    }
    
    
    
    /// 正在连接设备
    func deviceConnectingDevice() {
        self.activityView = NVActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.lineScale, color:MainColor , padding: 1)
        self.activityView.center = CGPoint(x: bgDisplayView.frame.width/2, y: bgDisplayView.frame.height/2)
        
        self.bgDisplayView.addSubview(self.activityView)
        scanFailLabel.isHidden = true
        self.bringSubview(toFront: self.bgDisplayView)
        self.activityView.startAnimating()
        
        
    }
    
    
    /// 连接设备成功
    func deviceConnectSuccess() {
        self.activityView.stopAnimating()
        print("connect success")
        self.bgMaskView.isHidden = false
        self.bringSubview(toFront: self.bgMaskView)
        
    }
    
    
    /// 连接设备失败
    func deviceConnectFail() {
        self.activityView.stopAnimating()
        self.bgMaskView.isHidden = true
        self.bringSubview(toFront: self.bgConnectFailView)
    }
    
    
    /// 连接成功是否配对成功
    ///
    /// - Parameter type: 配对成功与否标识
    func devicePairResult(type:DeviceScaningState) {
        
        
        bgPairView.isHidden = false
        self.bringSubview(toFront: bgPairView)
        let pairResultImage:UIImageView = bgPairView.viewWithTag(2000) as! UIImageView
        let pairLabel:UILabel = bgPairView.viewWithTag(2001) as! UILabel
                
        var startBtn:GeneralButton?
        if let startBtnTemp = bgPairView.viewWithTag(DeviceScaningTag.tag_BtnRightNowStart.code) as? GeneralButton {
            startBtn = startBtnTemp
        }
        else
        {
            startBtn = (bgPairView.viewWithTag(DeviceScaningTag.tag_BtnRescan.code) as! GeneralButton)
        }
        
        
        let noNeedBtn:GeneralButton = bgPairView.viewWithTag(DeviceScaningTag.tag_BtnNoNeed.code) as! GeneralButton
        
        if type == .Device_ConnectPairSuccess_State {
            
            pairResultImage.image = UIImage(named: "Bluetooth_successful")
            pairLabel.text = "DeviceSearchVC_pair_success".localiz()
            startBtn!.tag = DeviceScaningTag.tag_BtnRightNowStart.code
            noNeedBtn.isHidden = true
            
            
        } else if type == .Device_ConnectPairFaild_State {
            pairResultImage.image = UIImage(named: "Bluetooth_sfailure01")
            pairLabel.text = "DeviceSearchVC_pair_failure".localiz()
            startBtn!.tag = DeviceScaningTag.tag_BtnRescan.code
            startBtn!.setTitle("DeviceSearchVC_reSearch".localiz(), for: .normal)
            noNeedBtn.isHidden = false
            noNeedBtn.tag = DeviceScaningTag.tag_BtnNoNeed.code
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceScanmodelArray != nil ?  (self.deviceScanmodelArray?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"DeviceScancellId")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DeviceScancellId")
        }

        cell!.accessoryType = .disclosureIndicator

        
        let model = self.deviceScanmodelArray![indexPath.row]
        
        
        cell!.textLabel?.text = model.deviceName
        cell!.detailTextLabel?.text = model.macAdress
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let deviceArray = self.deviceScanmodelArray {
            
            if (self.didSelctCell != nil) {
                self.didSelctCell!(deviceArray[indexPath.row])
            }
        }
    }
 
}


extension DevcieScanIngVeiw {
    
    
    /// 显示连接成功或者失败对应的UI
    func creatConnectFailView()  {
        let imageView:UIImageView = UIImageView(image: UIImage.init(named: "Bluetooth_failure"))
        bgConnectFailView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(bgConnectFailView)
        }
        
        let connectFailLabel = UILabel()
        bgConnectFailView.addSubview(connectFailLabel)
        connectFailLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom)
            maker.left.right.equalTo(bgConnectFailView)
        }
        connectFailLabel.text = "DeviceSearchVC_connect_failure".localiz()
        connectFailLabel.textColor = .black
        connectFailLabel.textAlignment = .center
        
    }
    
    
    /// 配对前的引导界面
    func creactConnectSuccessView() {
        
        let whiteView = UIView()
        bgMaskView.addSubview(whiteView)
        whiteView.backgroundColor = .white
        whiteView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bgMaskView.snp.centerY)
            maker.left.right.equalTo(bgMaskView)
            maker.bottom.equalTo(bgMaskView)
        }
        
        let imageView:UIImageView = UIImageView(image: UIImage.init(named: "Bluetooth_Click"))
        whiteView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(whiteView)
            maker.centerX.equalTo(whiteView)
        }
        
        let connectSucessLabel = UILabel()
        whiteView.addSubview(connectSucessLabel)
        connectSucessLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom)
            maker.left.right.equalTo(whiteView)
        }
        connectSucessLabel.text = "DeviceSearchVC_connect_pair_tip".localiz()
        connectSucessLabel.textColor = .black
        connectSucessLabel.textAlignment = .center
        
    }
    
    
    /// 配对成功与失败对应的UI显示
    ///
    /// - Parameter type: 配对成功失败对应的标识
    func crectPairResultView(type:DeviceScaningState) {
        
        
        let imageView:UIImageView = UIImageView(image: UIImage.init(named: "Bluetooth_001"))
        bgPairView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(bgPairView).offset(-60)
            maker.centerX.equalTo(bgPairView)
        }
        
        let imageResultView:UIImageView = UIImageView(image: UIImage.init(named: "Bluetooth_successful"))
        imageResultView.tag = 2000
        bgPairView.addSubview(imageResultView)
        
        imageResultView.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView).offset(-10)
            maker.left.equalTo(imageView.snp.right).offset(-30)
        }
        
        
        let pairSucessLabel = UILabel()
        bgPairView.addSubview(pairSucessLabel)
        pairSucessLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(20)
            maker.left.right.equalTo(bgPairView)
        }
        pairSucessLabel.tag = 2001
        pairSucessLabel.text = "DeviceSearchVC_connect_pair_success".localiz()
        pairSucessLabel.textColor = .black
        pairSucessLabel.textAlignment = .center
    
        
        let startPairBtn = GeneralButton(frame: CGRect.zero, generalBtnTitle: "DeviceSearchVC_launching".localiz() as NSString)
       
        startPairBtn.generalBtnAction = {
            if self.didCleckBtn != nil {
                self.didCleckBtn!(startPairBtn.tag)
            }
        }
        
        bgPairView.addSubview(startPairBtn)
        startPairBtn.tag = DeviceScaningTag.tag_BtnRightNowStart.code
        startPairBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.left.equalTo(self).offset(15)
            maker.right.equalTo(self).offset(-15)
            maker.height.equalTo(50)
        }
        let noPairBtn = GeneralButton(frame: CGRect.zero, generalBtnTitle: "DeviceSearchVC_pair_notNeeded".localiz() as NSString)
       
        noPairBtn.generalBtnAction = {
            if self.didCleckBtn != nil {
                self.didCleckBtn!(noPairBtn.tag)
            }
        }
        
        bgPairView.addSubview(noPairBtn)
        noPairBtn.tag = DeviceScaningTag.tag_BtnNoNeed.code
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
