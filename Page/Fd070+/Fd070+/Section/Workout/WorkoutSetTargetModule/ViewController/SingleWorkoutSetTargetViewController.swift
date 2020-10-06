//
//  WokoutSetTargetViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/6.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class SingleWorkoutSetTargetViewController: UIViewController {

    struct Constant {
        static let distanceDefault = "5"
        static let scheduleDefault = "30"
    }
    let profileBtnView = ProfileButtonView()

    var scheduleScaleView = FDPickView()
    var distanceScaleView = FDPickView()

    var workoutSummaryModelLatest: WorkoutSummaryModel!
    var scheduleScaleViewDataSouce = [String]()
    var distanceScaleViewDataSource = [String]()

    var selectionTargetBlock:((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareDataUI()
        configUI()
        bindUI()
    }

    deinit {
        print("WokoutSetTargetViewController.deinit")
    }

    private func prepareDataUI() {

        //距离范围值是 1到50公里
        for i in 1 ... 50 {
            distanceScaleViewDataSource.append(i.description)
        }
        //时间范围值是 1分钟到5小时
        for i in 1 ... 60 * 5 {
            scheduleScaleViewDataSouce.append(i.description)
        }


        workoutSummaryModelLatest = try! WorkoutSummaryDataHelper.FindLatestWorkoutTarget(userID: CurrentUserID, macAddress: CurrentMacAddress)

        
    }
    private func configUI() {

        view.backgroundColor = UIColor.white

        navigationItem.title = "WorkoutVC_workoutSetTargetVC_title".localiz()

        profileBtnView.btnTitleNumber = Int(workoutSummaryModelLatest.target) ?? 0
        profileBtnView.btnTitleArr = ["WorkoutVC_workoutSetTargetVC_distance".localiz(),"WorkoutVC_workoutSetTargetVC_schedule".localiz()]
        view.addSubview(profileBtnView)

        profileBtnView.frame = CGRect.init(x: 0, y: navigationBarHeight + 15.auto(), width: view.width, height: 30)

        //时间的PickView
        scheduleScaleView.frame = CGRect.init(x: 20.auto(), y: profileBtnView.bottom + 20.auto(), width: view.frame.size.width - 40.auto(), height: view.frame.size.height / 2)
        scheduleScaleView.unitType = .Schedule
        //已保存的时间值
        scheduleScaleView.dataSource = scheduleScaleViewDataSouce

        view.addSubview(scheduleScaleView)


        //距离的PickView
        distanceScaleView.frame = scheduleScaleView.frame
        distanceScaleView.unitType = .distance
        //已保存的距离值
        distanceScaleView.dataSource = distanceScaleViewDataSource

        view.addSubview(distanceScaleView)

        self.showDistanceOrScheduleView(Int(workoutSummaryModelLatest.target) ?? 0)

        //保存的按钮
        let saveBtn = FDPublicButton()
        saveBtn.setButtonTitle("WorkoutVC_workoutSetTargetVC_save".localiz())
        saveBtn.publicBtnAction = {[unowned self] in
            self.saveWorkoutTarget()
        }
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (make) in

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
    private func bindUI() {

        //选中了具体的Index.
        profileBtnView.profileBtnAction = { [unowned self] sender in

            self.showDistanceOrScheduleView(sender)
            self.workoutSummaryModelLatest.target = sender.description
        }


        setDefaultView()
    }

    private func setDefaultView() {

        let selectedIndex = Int(workoutSummaryModelLatest.target) ?? 0
        if selectedIndex == 0 {
            //设置默认选中的值
            distanceScaleView.selectRow = scheduleScaleViewDataSouce.firstIndex(of: workoutSummaryModelLatest.target_value) ?? 1
            scheduleScaleView.selectRow = scheduleScaleViewDataSouce.firstIndex(of: Constant.scheduleDefault) ?? 1
        }else {
            //设置默认选中的值
            distanceScaleView.selectRow = scheduleScaleViewDataSouce.firstIndex(of: Constant.distanceDefault) ?? 1
            scheduleScaleView.selectRow = scheduleScaleViewDataSouce.firstIndex(of: workoutSummaryModelLatest.target_value) ?? 1
        }

    }

    private func showDistanceOrScheduleView(_ tag: Int) {
        if tag == 0 {
            self.distanceScaleView.isHidden = false
            self.scheduleScaleView.isHidden = true
        }else {
            self.distanceScaleView.isHidden = true
            self.scheduleScaleView.isHidden = false
        }
    }

}

// MARK: - Save data
extension SingleWorkoutSetTargetViewController {
    private func saveWorkoutTarget() {

        if !distanceScaleView.isHidden {
            workoutSummaryModelLatest.target_value = distanceScaleView.didSelectValue ?? Constant.distanceDefault
        }
        if !scheduleScaleView.isHidden {
            workoutSummaryModelLatest.target_value = scheduleScaleView.didSelectValue ?? Constant.scheduleDefault
        }

        //更新数据库
        let isUpdate = try! WorkoutSummaryDataHelper.update(item: workoutSummaryModelLatest)
        var alertMessage = "WorkoutVC_workoutSetTargetVC_saveResult_faile"
        if isUpdate {
            alertMessage = "WorkoutVC_workoutSetTargetVC_saveResult_success"
        }

        AlertTool.showAlertView(message: alertMessage.localiz(), cancalTitle: "Ok".localiz()) {
        }


        //回调设置的WoktouTarget
        if isUpdate, let selectionTarget = selectionTargetBlock{
            var selectionValue = ""
            if workoutSummaryModelLatest.target == "0" {
                selectionValue = workoutSummaryModelLatest.target_value + "WorkoutVC_workoutSetTargetVC_distanceUnit".localiz()
            }else {
                selectionValue = workoutSummaryModelLatest.target_value + "WorkoutVC_workoutSetTargetVC_scheduleUnit".localiz()
            }
            selectionTarget(selectionValue)
        }
        print(isUpdate)
    }
}
