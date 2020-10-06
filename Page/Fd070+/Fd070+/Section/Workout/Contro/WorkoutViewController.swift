//
//  WorkoutViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class WorkoutViewController: BaseViewController {
  
    struct Constant {
        static let mainSubViewHeightScale: CGFloat = 0.63
        
    }
    var workOutResultView: WorkOutResultView!
    
    var triggerButton: UIButton = UIButton()
    var setTargetBtn: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //ADD test View
        let longpressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPressAction))
        //FIXME: used debug model only
        self.view.addGestureRecognizer(longpressGesture)

        configUI()
        bindUI()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.workOutResultView.model = WorkOutResultManager.getLatestResultModel()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    private func configUI() {
        

        self.view.backgroundColor = UIColor.white
        
        workOutResultView = WorkOutResultView.init(frame: CGRect.init(x: 0, y: 0, width: view.width, height: Constant.mainSubViewHeightScale * view.height), isNewestData: true)
        workOutResultView.model = WorkOutResultManager.getLatestResultModel()
        view.addSubview(workOutResultView)
        workOutResultView.tapBlock = {[weak self] in
            let workoutHistoryViewController = WorkoutHistoryViewController()
            workoutHistoryViewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(workoutHistoryViewController, animated: true)
        }
        
        
        let startBtn = UIButton()
        startBtn.setImage(UIImage.init(named: "activity_start"), for: .normal)
        startBtn.addTarget(self, action: #selector(self.workoutBtnClick), for: .touchUpInside)
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            
            //默认是0  如果是4.0英寸(se/5s)返回值就是5, 如果是4.7英寸(6/7/8)返回值就是5,以此类推.. 6.5英寸full就是iPhone XS MAX.
            let margin = CGFloat(0.i40(1).i47(5).i55(12).i58full(15).i61full(20).i65full(40))
            make.bottom.equalToSuperview().inset(tabBarHeight + margin)
        }
        
        triggerButton = UIButton()
        triggerButton.isHidden = true
        view.addSubview(triggerButton)
        triggerButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            
        }
        
        view.layoutIfNeeded()
        
        //重新设置workOutResultView的高。5是一个固定值， workOutResultView内部是collectionCellSpace:CGFloat  = 5
        workOutResultView.height = workOutResultView.collectionView.bottom + 5

        FDLog(workOutResultView.height)
        setTargetBtn = getStartWorkoutBtn()
        let margin = CGFloat(0.i40(5).i47(2))
        setTargetBtn.bottom = startBtn.top + margin
        setTargetBtn.addTarget(self, action: #selector(self.setTargetBtnClick), for: .touchUpInside)
        view.addSubview(setTargetBtn)
        
        
    }
    
    private func bindUI() {
        self.navigationController?.delegate = self


        /// Monitoring table update..........
//        let _ = NotificationCenter.default.rx.notification(custom: .DBTableUpdate)
//            .takeUntil(self.rx.deallocated)
//            .subscribe({ [weak self] notification in
//                //数据库有变化，更新数据显示
//                let tableName = notification.element?.object as? TableNameEnum
//                switch tableName {
//                case  .workout_summary?:
//                    self?.workOutResultView.model = WorkOutResultManager.getLatestResultModel()
//                default:
//                    break
//                }
//            })

    }
}

// MARK: - Button Action
extension WorkoutViewController {
    
    @objc func setTargetBtnClick(sender: UIButton) {
        
        let wokoutSetTargetViewController = SingleWorkoutSetTargetViewController()
        wokoutSetTargetViewController.hidesBottomBarWhenPushed = true
        wokoutSetTargetViewController.selectionTargetBlock = {[unowned self] targetStr in
            self.setTargetBtn.setTitle(targetStr, for: .normal)
        }
        self.navigationController?.pushViewController(wokoutSetTargetViewController, animated: true)
    }
    
    @objc func workoutBtnClick(sender: UIButton) {

        if BleConnectState.getCurrentBleState() {
            let workoutInforViewController = WorkoutInforViewController()
            workoutInforViewController.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(workoutInforViewController, animated: true)
        }else {
            AlertTool.showAlertView(message: "Myday_BLEConnect_point".localiz(), cancalTitle: "Ok".localiz()) {[unowned self] in
                let vc = DeviceSelectDevcieViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    //Go to the test page
    @objc func longPressAction(gesture:UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let testModule = TestModuleViewController()
            testModule.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(testModule, animated: true)
            
        }
        
    }
}
extension WorkoutViewController {
    
    private func getStartWorkoutBtn() -> UIButton {
        
        let btnWidth = view.width / 2
        let btnX = (view.width - btnWidth) / 2
        let btnY = view.height - 200
        let btn = UIButton.init(frame: CGRect.init(x: btnX, y: btnY, width: btnWidth, height: btnWidth / 4))
        
        btn.setImage(UIImage.init(named: "back01_icon"), for: .normal)
        let btnTitle = WorkoutManger.getUserWorkoutTarget()
        btn.setTitle(btnTitle, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25.auto())
        btn.setTitleColor(UIColor.black, for: .normal)
        
        var btnImageWidth = btn.imageView!.bounds.size.width;
        var btnLabelWidth = btn.titleLabel!.bounds.size.width;
        let margin: CGFloat = 5
        
        btnImageWidth += margin
        btnLabelWidth += margin
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btnImageWidth , 0, btnImageWidth)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)
        
        return btn
    }
}

extension WorkoutViewController: FDPushEaseInAnimationPro, UINavigationControllerDelegate {
    
    var mainView: UIView {
        return view
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if toVC is WorkoutInforViewController, operation == UINavigationControllerOperation.push {
            return FDPushEaseInAnimation()
        }
        return nil
    }
}


