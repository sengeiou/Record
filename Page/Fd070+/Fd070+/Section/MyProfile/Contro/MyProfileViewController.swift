//
//  MyProfileViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseViewController {

    fileprivate struct Constant {
        static let MyProfileCellId = "MyProfileTableViewCellId"
    }
    
    var userInfoModel = UserInfoModel()
    
    var deviceInfoModelArray = [DeviceInfoModel]()
    let profileHeaderView = ProfileHeaderView()

    fileprivate  let tableView = UITableView.init(frame: CGRect.zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.separatorStyle = .singleLine
        $0.separatorColor = UIColor.hexColor(0xd1cfcf)
    }
    override func viewWillAppear(_ animated: Bool) {
        configData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        configNavUI()
        configUI()
        configData()

    }

    private func configUI(){

        view.backgroundColor = .white

        //导航栏
        self.title = "Tabbar_me".localiz()


        //profileHeaderView
        self.view.addSubview(profileHeaderView)
        profileHeaderView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(180)
            
        }
        profileHeaderView.tapBlock = {[unowned self] in
            let userInfoVC = UserInfoViewController()
            userInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(userInfoVC, animated: true)

        }


        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0.01
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(profileHeaderView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    
    private func configNavUI(){

        let img=UIImage(named:"add_icon")
        let item = UIBarButtonItem(image: img,style: UIBarButtonItemStyle.plain,target:self,action:#selector(addAction))
        item.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for: UIBarMetrics.default)
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func addAction(){

        //当前只能连接一个手环
        if deviceInfoModelArray.count > 0 {

            AlertTool.showAlertView(message: "请解除当前绑定手环, 再绑定新手环", cancalTitle: "OK") { }

            return
        }

        let vc = DeviceSelectDevcieViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //数据库查询
    private func configData(){

        //find UserinfoData
        userInfoModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID)
        profileHeaderView.myProfileDisplayData(userInfoModel)

        self.deviceInfoModelArray = try! DeviceInfoDataHelper.findAll() ?? []
        tableView.reloadData()

        /// Monitoring reloadIconData
        let _ = NotificationCenter.default.rx.notification(custom: .reloadIconData)
            .takeUntil(self.rx.deallocated)
            .subscribe({ [weak self] notification in
                self?.configData()
            })
        
    }
}
extension MyProfileViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceInfoModelArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cellid = "CellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellid)
        }

        let deviceModel = self.deviceInfoModelArray[indexPath.row]


        cell?.imageView?.image = UIImage.init(named: "Select_device")
        cell?.textLabel?.text = deviceModel.device_name
        cell?.textLabel?.textColor = UIColor.hexColor(0x727171)
        cell?.detailTextLabel?.text = "Myday_BLEConnectState_false".localiz()
        //如果当前连接的Mac地址相同且处于连接状态则标识已连接getCurrentBleState
        if (BleConnectState.getCurrentConnectMacAdress() == deviceModel.bt_mac) && BleConnectState.getCurrentBleState() {
            cell?.detailTextLabel?.text = "Myday_BLEConnectState_true".localiz()
        }

        cell?.detailTextLabel?.textColor = UIColor.hexColor(0x696969)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell!


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DeviceInfoVC = DeviceConnectViewController()
//        DeviceInfoVC.deviceInfoModel = self.deviceInfoModelArray[indexPath.row]
        DeviceInfoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(DeviceInfoVC, animated: true)
        print(".....")
    }
}

