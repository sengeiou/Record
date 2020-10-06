//
//  SelectContryViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/11.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import SnapKit

class SelectContryViewController: BaseViewController {

    fileprivate struct Constant {
        static let china = "China"
        static let unitedStates = "United States"
    }

    var contryArray = [String]()
    var lastCell = UITableViewCell()
    var lastIndexRow = 0
    var isFirstLogin = true
    var userModel = UserInfoModel()
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()


        configMainUI()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.tintColor = UIColor.white
    }


    private func configMainUI() {
//        if userModel.language == "1" {
//            lastIndexRow = 1
//        }
       if FDLanguageChangeTool.shared.currentLanguage != .zhHans {
            lastIndexRow = 1
        }
        view.backgroundColor = .white

        let describtLabel = UILabel.init()
        view.addSubview(describtLabel)
        describtLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationBarHeight + 20.auto())
            maker.centerX.equalToSuperview()
        }

        describtLabel.text = "UserInforCountryVC_selectContryMessage".localiz()
        describtLabel.font = UIFont.boldSystemFont(ofSize: 23.auto())
        describtLabel.textAlignment = .center
        describtLabel.textColor = UIColor.RGB(r: 157, g: 155, b: 155)
        contryArray = ["UserInforCountryVC_china".localiz(),"UserInforCountryVC_unitedStates".localiz()]

        tableView = UITableView()
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(describtLabel.snp.bottom).offset(20)
            maker.left.right.equalTo(view)
            maker.height.equalTo(150)
        }
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contryCell")

        if isFirstLogin {

            let nextBtn = GeneralButton(frame: CGRect.zero, generalBtnTitle: "NextStep".localiz() as NSString)

            nextBtn.generalBtnAction = {
                self.navigationController?.pushViewController(AccountSysViewController(), animated: true)
            }

            view.addSubview(nextBtn)

            nextBtn.snp.makeConstraints { (make) in

                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
                } else {
                    make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).inset(15)
                }
                make.left.equalTo(view).offset(15)
                make.right.equalTo(view).inset(15)
                make.height.equalTo(50)
            }
        }

    }

}
extension SelectContryViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contryArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier:"contryCell", for: indexPath)

        cell.textLabel?.text = contryArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.RGB(r: 157, g: 155, b: 155)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.auto())
        if lastIndexRow == indexPath.row {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if isFirstLogin {
            self.setCurrentCountry(indexPath)
            return
        }

        AlertTool.showAlertView(title: "UserInformationVC_ChangeCountry_point".localiz(), message: "") { (index) in

            if index == 0 {
                self.setCurrentCountry(indexPath)
            }
        }
    }
}
// MARK: - Rest user Model
extension SelectContryViewController {

    func setCurrentCountry(_ indexPath: IndexPath) {

        self.lastCell.accessoryType = .none
        lastIndexRow = indexPath.row

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        self.lastCell = cell!
        let row = indexPath.row

        self.tableView.reloadData()
        let selectedLanguage: Languages = row == 0 ? .zhHans : .en

        // change the language
        FDLanguageChangeTool.shared.setLanguage(language: selectedLanguage)

        //更新地区选择
        let countrySelect = indexPath.row.description
        //现阶段只有中文和英文。 0 代表 英制。 1代表公制。 3.7
        var calculatingSelect = "1"

        if indexPath.row == 1 {
            calculatingSelect = "0"
        }

        /**
         此时应把数据存在本地，不应放在数据库,因为现在这里的业务逻辑是在用户登录前选择国家地区.
         没有usderId不建数据库，等登录成功后，把本地国家设置转存到数据库。
         */
        if isFirstLogin {

            UserDefaults.ContryInfoKey.calculating.store(value: calculatingSelect)
            UserDefaults.ContryInfoKey.country.store(value: countrySelect)
        }else {

            userModel.language = countrySelect
            userModel.calculating = calculatingSelect

            //更新数据库
            UserInfoManager.updateUserInfo(self.userModel)
            //数据上传服务器
            FDCircularProgressLoadTool.shared.show(message: "Uploading".localiz())
            UserInfoManager.uploadUserInformation(userModel: self.userModel) { (result) in

                FDCircularProgressLoadTool.shared.dismiss()

                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.changeRootViewController()

            }

        }
    }


}



