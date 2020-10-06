//
//  UserInfoViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/13.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {
    
    fileprivate struct Constant {
        static let UserInfoCellId = "UserInfoTableViewCellId"
        static let firstRowHeight: CGFloat = 200
        static let otherRowHeight: CGFloat = 50
    }
    var userManager = UserInfoManager()

    var userInfoTitleArr = [String]()
    
    var userInfoModel = UserInfoModel()
    var temporaryUserInfoModel = UserInfoModel()
    
    fileprivate  let tableView = UITableView.init(frame: CGRect.zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.separatorStyle = .singleLine
        $0.separatorColor = UIColor.hexColor(0xd1cfcf)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configData()
        configUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !isMovingToParentViewController {
            return
        }
        
        FDCircularProgressLoadTool.shared.show(message: "Loading".localiz())
        UserInfoManager.downloadUserInformation(language: self.userInfoModel.language ) { [unowned self] (userInfoModel, result) in
            
            DispatchQueue.main.async {
                
                FDCircularProgressLoadTool.shared.dismiss()

                self.userInfoModel = userInfoModel
                self.temporaryUserInfoModel = userInfoModel

                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if !isMovingFromParentViewController {
            return
        }
        let Login_Token = UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue
        
        guard let _ = Login_Token else {
            return
        }

        if userInfoModel == temporaryUserInfoModel {
            return
        }

        FDCircularProgressLoadTool.shared.show(message: "Uploading".localiz())
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        group.enter()  //Update current
        queue.async(group: group, execute: {
            
            UserInfoManager.uploadUserIcon(userModel: self.userInfoModel) {[weak self](model, result) in
                print("uploadUserIconResult\(result)")
                DispatchQueue.main.async {

                    self?.userInfoModel.icon = model?.icon ?? ""
                }
                group.leave()
                
            }
            
        })
        
        group.notify(queue: queue){
            UserInfoManager.uploadUserInformation(userModel: self.userInfoModel) {(result) in

                DispatchQueue.main.async {
                    NotificationCenter.post(custom: .reloadIconData)

                    FDCircularProgressLoadTool.shared.dismiss()
                }
            }
            
            
        }
    }
    
    private func configUI(){

        self.title = "UserInformationVC_VCTitle".localiz()
        self.view.backgroundColor = UIColor.white

        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        tableView.register(UserInfoHeaderTableViewCell.self, forCellReuseIdentifier: Constant.UserInfoCellId)
        
        
        userInfoTitleArr = ["UserInformationVC_gender".localiz(),
                            "UserInformationVC_height".localiz(),
                            "UserInformationVC_weight".localiz(),
                            "UserInformationVC_birthday".localiz(),
                            "UserInformationVC_goal".localiz(),
                            "UserInformationVC_country".localiz()
        ]
        
        let logoutView = DeviceFooterView()
        logoutView.deleteBtn.setTitle("UserInformationVC_logout".localiz(), for: .normal)
        logoutView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80.auto())
        logoutView.deleteBtnAction = {[unowned self] in
            
            AlertTool.showAlertView(title: "UserInformationVC_logout_point".localiz(), message: "") {(index) in
                print(index)
                if index == 0 {
                    self.sigoutBtnClick()
                }
            }
            
        }
        tableView.tableFooterView = logoutView
        
        
    }
    
    private func configData(){

        getUserInfoModel()

        /// Monitoring table update..........
        let _ = NotificationCenter.default.rx.notification(custom: .DBTableUpdate)
            .takeUntil(self.rx.deallocated)
            .subscribe({ [weak self] notification in
                //数据库有变化，更新数据显示
                let tableName = notification.element?.object as? TableNameEnum
                switch tableName {
                case  .userinfo?:
                    self?.getUserInfoModel()
                default:
                    break
                }
            })
        
    }

    private func getUserInfoModel() {
        //find
        do {
            self.userInfoModel = try UserinfoDataHelper.findFirstRow(userID: CurrentUserID)

        } catch _ {
            FDLog("find UserinfoData error")
        }
        self.tableView.reloadData()
    }
    
    func sigoutBtnClick() {
        
        
        let exists = try! DeviceInfoDataHelper.checkTableExists()
        if exists {
            //移除设备
            let bledataMana = BleDataManager.instance
            do {
                try DeviceInfoDataHelper.delete(item: bledataMana.currentHandleDeviceModel!)
            } catch _ {
                print("Delete error")
            }
            bledataMana.bleOperationMana.removeBindDevice()
        }
        FDCircularProgressLoadTool.shared.show(message: "Loading".localiz())
        //上传必要的信息
        NetworkDataSyncManager.loginOut { (retult) in
            
            FDCircularProgressLoadTool.shared.dismiss()
            //移除登录信息
            UserDefaults.LoginSuccessUserDefault.Login_Token.removed()

            //切换根视图
            AppDelegate.getDelegate().window!.rootViewController = UINavigationController.init(rootViewController: AccountSysViewController())
            
        }
        
    }
    
    
}
extension UserInfoViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return Constant.firstRowHeight
        }else{
            return Constant.otherRowHeight
        }
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return Constant.otherRowHeight
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //        return signoutView
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let userInfoHeaderCell = tableView.dequeueReusableCell(withIdentifier: Constant.UserInfoCellId, for: indexPath) as! UserInfoHeaderTableViewCell
            
            userInfoHeaderCell.selectionStyle = UITableViewCellSelectionStyle.none
            userInfoHeaderCell.userInfoDisplayData(userInfoModel)
            
            
            return userInfoHeaderCell
        }else{
            
            let cellid = "testCellID"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
            if cell==nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: cellid)
            }
            
            cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 23.auto())
            cell?.textLabel?.text = userInfoTitleArr[indexPath.row - 1]
            cell?.textLabel?.textColor = UIColor.RGB(r: 101, g: 100, b: 100)
            cell?.detailTextLabel?.textColor = UIColor.hexColor(0x696969)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            let userModel = self.userInfoModel
            
            if indexPath.row == 1{
                cell?.detailTextLabel?.text = self.userManager.getGender(gender: userModel.gender)
            }
            if indexPath.row == 2{
                cell?.detailTextLabel?.text = self.userManager.getHeightUnits(userModel:userModel)
            }
            if indexPath.row == 3{
                cell?.detailTextLabel?.text = self.userManager.getWeightUnits(userModel: userModel)
            }
            if indexPath.row == 4{
                cell?.detailTextLabel?.text = self.userManager.getBirthDaystr(birthDay: userModel.birthday)
            }
            if indexPath.row == 5{
                let stepUnit = "MydayVC_step_unit".localiz()
                cell?.detailTextLabel?.text = "\(userModel.goal)" + stepUnit
            }
            if indexPath.row == 6{
                cell?.detailTextLabel?.text = UserInfoManager.coverCountryCodeToCountryString(userModel.language)
            }
            
            return cell!
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true);
        switch indexPath.row {
        case 0:
            let VC = NameViewController()
            VC.isFirstLogin = false
            VC.userModel = self.userInfoModel
            navigationController?.pushViewController(VC, animated: true)
        case 1:
            let VC = GenderViewController()
            VC.isFirstLogin = false
            VC.userModel = self.userInfoModel
            navigationController?.pushViewController(VC, animated: true)
        case 2:
            let VC = HeightViewController()
            VC.isFirstLogin = false
            VC.userModel = self.userInfoModel
            navigationController?.pushViewController(VC, animated: true)
        case 3:
            let VC = WeightViewController()
            VC.isFirstLogin = false
            VC.userModel = self.userInfoModel
            navigationController?.pushViewController(VC, animated: true)
        case 4:
            let VC = BirthDayViewController()
            VC.isFirstLogin = false
            VC.userModel = self.userInfoModel
            navigationController?.pushViewController(VC, animated: true)
        case 5:
            let VC = TargetViewController()
            VC.userModel = self.userInfoModel
            VC.isFirstLogin = false
            navigationController?.pushViewController(VC, animated: true)
        case 6:
            let VC = SelectContryViewController()
            VC.userModel = self.userInfoModel
            VC.isFirstLogin = false
            navigationController?.pushViewController(VC, animated: true)
        default:
            print("dddd")
        }
    }
}
