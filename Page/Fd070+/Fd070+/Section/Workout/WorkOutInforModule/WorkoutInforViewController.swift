//
//  WorkoutInforViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/6.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkoutInforViewController: UIViewController {

    private var workoutInforView: WorkoutInforView!

    private var workOutCountDownView: WorkOutCountDownView!

    private var workoutSeconds = 0

    private var defaultWorkoutInforModel = WorkoutInforManager.getWorkoutInforModel()

    private var workOutResultView: WorkOutResultView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        bindUI()
    }

    override func viewWillDisappear(_ animated: Bool) {

//        FDCircularProgressLoadTool.shared.show(message: "Uploading".localiz())
        NetworkDataSyncManager.uploadWorkoutData { (result) in
//            FDCircularProgressLoadTool.shared.dismiss()

        }
    }

    deinit {
        print("WorkoutInforViewController.deinit")
    }

    private func configUI() {


        self.view.backgroundColor = MainColor

        workOutCountDownView = WorkOutCountDownView.init(frame: self.view.bounds)
        view.addSubview(workOutCountDownView)
        workOutCountDownView.countDownOverBlock = { [weak self] in
            self?.workOutCountDownView.removeFromSuperview()
            self?.workoutInforView.isHidden = false
            //Start workout
            BleDataManager.instance.sendStartWorkoutToDevice()
        }



        workoutInforView = WorkoutInforView.init(frame: view.bounds)
        //设置Y坐标
        workoutInforView.y = -navigationBarHeight
        workoutInforView?.model = defaultWorkoutInforModel
        workoutInforView.isHidden = true
        view.addSubview(workoutInforView!)

        workOutResultView = WorkOutResultView.init(frame: CGRect(x: 0, y: statusBarHeight, width: view.width, height: view.height), isNewestData: false)
        //        workOutResultView.y = -navigationBarHeight

    }

    private func bindUI() {


        workoutInforView.currentWorkoutStateBlock = { [unowned self] workoutState  in
            switch workoutState {
            case .pause:
                self.workoutPause()
            case .goOn:
                self.workoutContinue()
            case .end:
                self.workoutFinish()
            default:
                break
            }
        }

        BleDataManager.instance.refreshWorkoutRTDataCallBlock = { [weak self]model in

            guard let self = self else {
                return
            }

            self.defaultWorkoutInforModel.value = model.distance
            self.defaultWorkoutInforModel.step = model.step
            self.defaultWorkoutInforModel.hearRate = model.hr
            self.defaultWorkoutInforModel.calorie = model.calorie
            self.defaultWorkoutInforModel.durationSecond = WorkoutInforManager.getWorkoutDurationString(model.workoutDuration)

            DispatchQueue.main.async {
                self.workoutInforView?.model = self.defaultWorkoutInforModel
            }

        }

    }


}

extension WorkoutInforViewController {

    private func workoutContinue() {

        defaultWorkoutInforModel.state = "运动中"
        workoutInforView?.model = defaultWorkoutInforModel

        BleDataManager.instance.sendStartWorkoutToDevice()


    }

    private func workoutPause() {

        //Pauser workout
        BleDataManager.instance.sendPauseWorkoutToDevice()

        defaultWorkoutInforModel.state = "运动暂停"
        workoutInforView?.model = defaultWorkoutInforModel
    }

    private func workoutFinish() {

        FDCircularProgressLoadTool.shared.show()

        //Stop workout
        BleDataManager.instance.sendStopWorkoutToDevice()

        //Get workout data
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            BleDataManager.instance.sendGetWorkoutDataFromDevice()
        }

        //TODO: 运动结束后，还未生成Workou数据，就不能获取到数据了.Bug. (手环应上报数据是否存储完成)
        DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + .seconds(2)) {

            self.workOutResultView.model = WorkOutResultManager.getWorkOutResultModel()
            self.view.insertSubview(self.workOutResultView, aboveSubview: self.workoutInforView!)
            FDCircularProgressLoadTool.shared.dismiss()
        }

    }
}
