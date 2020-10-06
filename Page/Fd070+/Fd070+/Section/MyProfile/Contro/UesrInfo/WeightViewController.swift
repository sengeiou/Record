//
//  WeightViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class WeightViewController: BaseViewController {

    let unitLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.RGB(r: 133, g: 133, b: 133)
        label.layer.cornerRadius = 15.auto()
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    var isFirstLogin : Bool!

    let userInfoHerderView = UserInfoHeaderView()

    fileprivate let titleLabel = UILabel().then() {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
    }

    private var  lbsPickerView = FDPickView()
    private var  kgPickerView = FDPickView()

    var userModel: UserInfoModel!

    var userManager = UserInfoManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        self.configUI()

    }

    override func viewWillDisappear(_ animated: Bool) {
        if isEditing {
            saveWeightData()
        }
    }


    private func configUI(){

        self.title = "UserInformationVC_VCTitle".localiz()
        userInfoHerderView.isHidenProgress(hidden: true)
        userInfoHerderView.getProgressValueAndTitle(progressValue: 0.8, title: "UserInformationVC_weight".localiz())
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

        if userModel.calculating == "0"{
            lbsPickerView.frame = CGRect(x: pickerViewX, y: pickerViewY, width: pickerViewWidth, height: pickerViewHeight)

            unitLabel.text = "FT/IN"
            view.addSubview(lbsPickerView)
            lbsPickerView.unitType = .weightPound
            lbsPickerView.dataSource = userManager.getScaleDataSource(30 ... 350)
            lbsPickerView.didSelectValueBlock = { [unowned self]_ in
                self.isEditing = true
            }

            var weightIndex = ""

            //本身存的就是英制
            if userModel.weight.contains(".") {
                var weightValue = userModel.weight
                weightValue.remove(at: weightValue.firstIndex(of: ".")!)
                weightIndex = weightValue
            }else {
                //存的不是英制
                weightIndex = userManager.getKGSwitchLBSRow(weightValue: userModel.weight)

            }
            lbsPickerView.selectRow = lbsPickerView.dataSource.firstIndex(of: weightIndex) ?? 0
        } else {

            //距离的PickView
            kgPickerView.frame = CGRect(x: pickerViewX, y: pickerViewY, width: pickerViewWidth, height: pickerViewHeight)
            view.addSubview(kgPickerView)
            kgPickerView.unitType = .weightMetric

            unitLabel.text = "公制"
            //已保存的距离值
            kgPickerView.dataSource = userManager.getScaleDataSource(30 ... 300)
            kgPickerView.didSelectValueBlock = {[unowned self] _ in
                self.isEditing = true
            }

            var weightIndex = ""
            //本身存的就是英制
            if userModel.weight.contains(".") {

                var weightValue = userModel.weight
                weightValue.remove(at: weightValue.firstIndex(of: ".")!)
                weightIndex = weightValue

                weightIndex = userManager.getLBSSwitchKGRow(weightValue: weightValue)

            }else {
                //存的不是英制
                weightIndex = userModel.weight

            }
            kgPickerView.selectRow = kgPickerView.dataSource.firstIndex(of: weightIndex) ?? 0
        }

    }

    func firstLoginSetup() {
        if isFirstLogin == true {
            userInfoHerderView.isHidenProgress(hidden: false)
            let nextBtn = FDPublicButton()
            nextBtn.publicBtnAction = {
                self.saveWeightData()
                let vc = BirthDayViewController()
                vc.userModel = self.userModel
                vc.isFirstLogin = true
                self.navigationController?.pushViewController(vc, animated: true)
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
extension WeightViewController {
    func saveWeightData() {

        if userModel.calculating == "0" {
            let weightValue = self.lbsPickerView.didSelectValue ?? ""
            userModel.weight = weightValue + "."
        }else {

            userModel.weight = self.kgPickerView.didSelectValue ?? ""
        }
        UserInfoManager.updateUserInfo(self.userModel)
    }
}
