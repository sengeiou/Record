//
//  DeviceConnectViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/12.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class DeviceConnectViewController: BaseViewController {
    
    fileprivate struct Constant {
        static let DialStyleCellId = "DialStyleTableViewCellId"
    }
    let heartBtnSwitch = UISwitch()
    let synBtnSwitch = UISwitch()
    
    fileprivate var deviceInfoModel = DeviceInfoModel()

    fileprivate  var temporaryDeviceInfoModel = DeviceInfoModel()
    /// 测试使用
    let bleOtaMana = BleOTAManager.init()
    
    var otaView:OtaUploadMaskView?

    var firmwareUpdateState = false

    fileprivate  let tableView = UITableView.init(frame: CGRect.zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.separatorStyle = .singleLine
        $0.separatorColor = UIColor.hexColor(0xd1cfcf)
    }
    
    var sectionArr = [String]()
    var deviceTitleArr = [String]()
    var deviceValueArr = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        bindData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if !isMovingToParentViewController {
            return
        }
        
        FDCircularProgressLoadTool.shared.show(message: "Loading".localiz())
        DeviceManager.downloadDeviceInformation { [weak self] (deviceModel, resutl) in

            DispatchQueue.main.async {

                self?.deviceInfoModel = deviceModel
                self?.temporaryDeviceInfoModel = deviceModel
                self?.setDeviceValueArrData()
                self?.tableView.reloadData()

                FDCircularProgressLoadTool.shared.dismiss()
            }

        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {

        //Save to dataBase
        let _  = try! DeviceInfoDataHelper.update(item: deviceInfoModel)

        if !isMovingFromParentViewController {
            return
        }
        //没有做修改
        if deviceInfoModel == temporaryDeviceInfoModel {
            return
        }

        
        //View controller was popped
        FDCircularProgressLoadTool.shared.show(message: "Uploading".localiz())
        DeviceManager.uploadDeviceInformation(deviceModel: deviceInfoModel) { (result) in
            FDCircularProgressLoadTool.shared.dismiss()
            
        }
    }
    
    
    private func configUI()
    {
         self.title = "DeviceVC_title".localiz()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0.01
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(view)
            make.bottom.equalTo(0)
        }
        
        tableView.register(DialStyleTableViewCell.self, forCellReuseIdentifier: Constant.DialStyleCellId)
        
        let headerView = DeviceHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 280)
        headerView.changeHeaderViewDisplay(deviceModel: deviceInfoModel)
        tableView.tableHeaderView = headerView
        
        let footView = DeviceFooterView()
        footView.deleteBtn.setTitle("DeviceVC_deleteDevice_title".localiz(), for: .normal)
        footView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80.auto())
        footView.deleteBtnAction = {[unowned self] in
            
            AlertTool.showAlertView(title: "DeviceVC_deleteDevice_title".localiz(), message: "DeviceVC_deleteDevice_message".localiz()) { (index) in
                print(index)
                if index == 0 {
                    print("删除设备")
                    self.deleteBtnClick()
                }
            }
            
        }
        tableView.tableFooterView = footView
        
        sectionArr = ["DeviceVC_dialStyle".localiz(),
                      "DeviceVC_configurationDevice".localiz()]
        
        deviceTitleArr = ["DeviceVC_customaryUnit".localiz(),
                          "DeviceVC_continuousHRTest".localiz(),
                          "DeviceVC_AutomaticSynchronizationAroundTheClock".localiz(),
                          "DeviceVC_habitualHand".localiz(),
                          "DeviceVC_newVersionUpdate".localiz(),
                          "DeviceVC_reset".localiz(),
                          "DeviceVC_help".localiz(),
                          "DeviceVC_hardWareVersion".localiz(),
                          "DeviceVC_appWareVersion".localiz()]


        setDeviceValueArrData()
    }


    func bindData() {
        DeviceManager.checkBleisNeedUpdate { (isNeedUpdate) in
            if isNeedUpdate {

                self.firmwareUpdateState = isNeedUpdate

                self.tableView.reloadRows(at: [IndexPath(row: 7, section: 1)], with: .none)
            }
        }
    }
    func setDeviceValueArrData() {
        var customary_unit = "DeviceVC_customaryUnit_british".localiz()
        if deviceInfoModel.customary_unit == "0" {
            customary_unit = "DeviceVC_customaryUnit_metric".localiz()
        }
        var customary_hand = "DeviceVC_habitualHand_left".localiz()
        if deviceInfoModel.customary_hand == "0" {
            customary_hand = "DeviceVC_habitualHand_right".localiz()
        }
        deviceValueArr = [customary_unit,
                          deviceInfoModel.hr_test_switch,
                          deviceInfoModel.automatic_sync,
                          customary_hand,
                          "DeviceVC_hasBeenUpdated".localiz(),
                          deviceInfoModel.bt_mac ,
                          "DeviceVC_developing".localiz(),
                          deviceInfoModel.band_version,
                          CurrentAppVersion]
    }
    
    
}

extension DeviceConnectViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    // 每组的头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return deviceTitleArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myDayHeadView = DeviceSectionView()
        myDayHeadView.dayDateLabel.text = sectionArr[section]
        return myDayHeadView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let dialStyleCell = tableView.dequeueReusableCell(withIdentifier: Constant.DialStyleCellId, for: indexPath) as! DialStyleTableViewCell
            //传入当前选择的表盘
            dialStyleCell.setBtnNumberWith(tag: 0)
            //   表盘样式选择
            dialStyleCell.DialStyleBtnAction = { sender in
                print("选择了%d",sender)
            }
            dialStyleCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return dialStyleCell
        }
        else
        {
            let cellid = "testCellID"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellid)

            let cellSublayers = cell?.contentView.layer.sublayers
            if cellSublayers != nil {
                for sublayer in cellSublayers! {
                    guard let _ = sublayer.name else {
                        continue
                    }
                    sublayer.removeFromSuperlayer()
                }
            }

            if cell==nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: cellid)
            }
            
            cell?.textLabel?.textColor = UIColor.hexColor(0x414141)
            cell?.textLabel?.text = deviceTitleArr[indexPath.row]
            
            cell?.detailTextLabel?.textColor = UIColor.hexColor(0x696969)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.detailTextLabel?.text = ""
            cell?.accessoryType = UITableViewCellAccessoryType.none
            switch indexPath.row {
            case 0:
                cell?.detailTextLabel?.text = deviceValueArr[indexPath.row]
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
                
            case 1:
                heartBtnSwitch.frame = CGRect(x: SCREEN_WIDTH - 70, y: 10, width: 40, height: 10)
                heartBtnSwitch.onTintColor = MainColor
                heartBtnSwitch.tintColor = MainColor
                heartBtnSwitch.tag = indexPath.row
                heartBtnSwitch.addTarget(self, action: #selector(btnSwitchOnorOff(switchState:)), for: UIControlEvents.valueChanged)
                if deviceValueArr[1] == "1"{
                    heartBtnSwitch.isOn = true
                }else{
                    heartBtnSwitch.isOn = false
                }
                
                cell?.contentView.addSubview(heartBtnSwitch)
                break
                
            case 2:
                synBtnSwitch.frame = CGRect(x: SCREEN_WIDTH - 70, y: 10, width: 40, height: 10)
                synBtnSwitch.onTintColor =  MainColor
                synBtnSwitch.tintColor =  MainColor
                synBtnSwitch.tag = indexPath.row
                synBtnSwitch.addTarget(self, action: #selector(btnSwitchOnorOff(switchState:)), for: UIControlEvents.valueChanged)
                if deviceValueArr[2] == "1"{
                    synBtnSwitch.isOn = true
                }else{
                    synBtnSwitch.isOn = false
                }
                cell?.contentView.addSubview(synBtnSwitch)
                break
                
            case 3,4,5,6:
                cell?.detailTextLabel?.text = deviceValueArr[indexPath.row]
                cell?.detailTextLabel?.adjustsFontSizeToFitWidth = true
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            case 7:

                if firmwareUpdateState {
                    let redDotLayer = CAShapeLayer()
                    redDotLayer.name = "redDotLayer"
                    redDotLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 8, height: 8)).cgPath
                    redDotLayer.frame = CGRect.init(x: (cell?.detailTextLabel?.frame.maxX)!, y: (cell?.detailTextLabel?.frame.minY)! - 8, width: 8, height: 8)
                    redDotLayer.fillColor = UIColor.red.cgColor
                    cell?.contentView.layer.addSublayer(redDotLayer)
                }

                cell?.detailTextLabel?.text = deviceValueArr[indexPath.row]
                case 8:
                cell?.detailTextLabel?.text = deviceValueArr[indexPath.row]
            default:
                break
            }
            
            return cell!
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            switch indexPath.row {
                
            case 0:
                showCustomaryUnitSelectView()
            case 3:
                showCustomaryHandleSelectView()
            case 5:
                AlertTool.showAlertView(title: "", message: "DeviceVC_reset_warn".localiz()) { (tag) in
                    if tag == 0 {
                        BleDataManager.instance.sendFactoryResetToDevice()
                    }
                }

            case 7:
                if firmwareUpdateState {
                    bleOtaMana.startOtaInteraction()
                }
            default:
                break
            }
            
        }
    }
}

// MARK: - Action handle
extension DeviceConnectViewController {
    
    func showCustomaryUnitSelectView() {

        let unitDataSouce = ["DeviceVC_customaryUnit_metric".localiz(),
                             "DeviceVC_customaryUnit_british".localiz()]

        FDPickSelectView.shared.show(title: "DeviceVC_customaryUnit".localiz(), dataSource: unitDataSouce, defalutSelectedIndex: Int((deviceInfoModel.customary_unit)) ?? 0) { [unowned self] (index) in
            self.deviceInfoModel.customary_unit = index.description
            self.deviceValueArr[0] = unitDataSouce[index]
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
            }
        }
    }
    
    func showCustomaryHandleSelectView() {
        let handDataSouce = ["DeviceVC_habitualHand_right".localiz(),
                             "DeviceVC_habitualHand_left".localiz()]

        FDPickSelectView.shared.show(title: "DeviceVC_habitualHand".localiz(), dataSource: handDataSouce, defalutSelectedIndex: Int(deviceInfoModel.customary_hand) ?? 0) { [unowned self] (index) in
            self.deviceInfoModel.customary_hand = index.description
            self.deviceValueArr[3] = handDataSouce[index]
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 1)], with: .none)
            }
        }
        
    }
    
    @objc func btnSwitchOnorOff(switchState:UISwitch) {

        let switchTag = switchState.tag
        let switchState = switchState.isOn
        
        if switchTag == 1 {

            if switchState {
                deviceValueArr[1] = "1"
                deviceInfoModel.hr_test_switch = "1"
            }else {
                deviceValueArr[1] = "0"
                deviceInfoModel.hr_test_switch = "0"
            }
        }else {
            if switchState {
                deviceValueArr[2] = "1"
                deviceInfoModel.automatic_sync = "1"
            }else {
                deviceValueArr[2] = "0"
                deviceInfoModel.automatic_sync = "0"
            }
        }



    }
    
    fileprivate func deleteBtnClick() {
        
        let bledataMana = BleDataManager.instance
        
        guard let deviceModel =  bledataMana.currentHandleDeviceModel else {
            return
        }
        
        do {
            try DeviceInfoDataHelper.delete(item: deviceModel)
        } catch _ {
            print("Delete error")
        }
        
        bledataMana.bleOperationMana.removeBindDevice()
        
        FDCircularProgressLoadTool.shared.show(message: "Deleting".localiz())
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            FDCircularProgressLoadTool.shared.dismiss()
            self.navigationController?.popViewController(animated: true)
        })
        
    }
}
