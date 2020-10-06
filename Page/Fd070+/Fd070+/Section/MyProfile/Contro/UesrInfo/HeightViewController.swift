//
//  HeightViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class HeightViewController: BaseViewController {


    let unitLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.RGB(r: 133, g: 133, b: 133)
        label.layer.cornerRadius = 15.auto()
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    let userInfoHerderView = UserInfoHeaderView()
    
    private var heightInchPickerView = FDHeightInchPickerView()
    private var cmPickerView = FDPickView()
    
    var userModel = UserInfoModel()
    var userManager = UserInfoManager()
    
    var isFirstLogin : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        configUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isEditing {
            
            saveHeightData()
        }
    }

    private func configUI(){
        
        self.title = "UserInformationVC_VCTitle".localiz()
        
        userInfoHerderView.isHidenProgress(hidden: true)
        userInfoHerderView.getProgressValueAndTitle(progressValue: 0.6, title: "UserInformationVC_height".localiz())
        self.view.addSubview(userInfoHerderView)

        userInfoHerderView.snp.makeConstraints { (make) in
            make.top.equalTo(20.auto())
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(80.auto())
        }
        
        view.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(userInfoHerderView.snp.bottom).offset(10.auto())
            make.size.equalTo(CGSize.init(width: 70.auto(), height: 40.auto()))
        }
        
        view.layoutIfNeeded()
        
        pickerViewSetup()
        firstLoginSetup()
        
    }

    func pickerViewSetup() {
        let pickerViewX: CGFloat = 20.auto()
        let pickerViewY: CGFloat = unitLabel.bottom + 10
        let pickerViewWidth: CGFloat = view.width - (pickerViewX * 2)
        let pickerViewHeight: CGFloat = view.height * 0.44


        if userModel.calculating == "0" {
            heightInchPickerView.frame = CGRect(x: pickerViewX, y: pickerViewY, width: pickerViewWidth, height: pickerViewHeight)

            unitLabel.text = "FT/IN"
            view.addSubview(heightInchPickerView)

            var dataSource = HeightInchModel()
            dataSource.intDataSource = userManager.getScaleDataSource(3 ... 50)
            dataSource.floatDataSource = userManager.getScaleDataSource(0 ... 9)
            heightInchPickerView.dataSource = dataSource
            heightInchPickerView.didSelectValueBlock = { [unowned self]_ in
                self.isEditing = true
            }

            var heightInt = ""
            var heightFloat = ""
            //本身存的就是英制
            if userModel.height.contains(".") {
                let heightComponents = userModel.height.components(separatedBy: ".")
                heightInt = heightComponents.first ?? "0"
                heightFloat = heightComponents.last ?? "0"
            }else {
                //存的不是英制
                let heightInch = userManager.getCMSwitchFootRow(heightValue: userModel.height)
                let heightComponents = heightInch.components(separatedBy: ".")
                heightInt = heightComponents.first ?? "0"
                heightFloat = heightComponents.last ?? "0"

            }

            heightInchPickerView.intPickerViewSelectRow = dataSource.intDataSource.firstIndex(of: heightInt) ?? 0
            heightInchPickerView.floatPickerViewSelectRow = dataSource.floatDataSource.firstIndex(of: heightFloat) ?? 0


        } else {

            //距离的PickView
            cmPickerView.frame = CGRect(x: pickerViewX, y: pickerViewY, width: pickerViewWidth, height: pickerViewHeight)
            view.addSubview(cmPickerView)
            cmPickerView.unitType = .heightMetric

            unitLabel.text = "公制"
            //已保存的距离值
            cmPickerView.dataSource = userManager.getScaleDataSource(30 ... 300)
            cmPickerView.didSelectValueBlock = {[unowned self] _ in
                self.isEditing = true
            }

            var heightIndex = ""
            //本身存的就是英制
            if userModel.height.contains(".") {

                heightIndex = userManager.getFootSwitchCMRow(heightValue: userModel.height)


            }else {
                //存的不是英制
                heightIndex = userModel.height

            }

            cmPickerView.selectRow = cmPickerView.dataSource.firstIndex(of: heightIndex) ?? 0
        }
    }

    func firstLoginSetup() {

        if isFirstLogin == true {
            userInfoHerderView.isHidenProgress(hidden: false)
            let nextBtn = FDPublicButton()
            nextBtn.publicBtnAction = {

                self.saveHeightData()

                let weightViewController = WeightViewController()
                weightViewController.userModel = self.userModel
                weightViewController.isFirstLogin = true
                self.navigationController?.pushViewController(weightViewController, animated: true)
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
        }else {

        }
    }
    
}
extension HeightViewController {
    
    func saveHeightData() {
        
        
        if userModel.calculating == "0" {
            userModel.height = heightInchPickerView.didSelectValue
        }else {
            
            userModel.height = cmPickerView.didSelectValue ?? ""
        }
        UserInfoManager.updateUserInfo(self.userModel)
        
    }
}
