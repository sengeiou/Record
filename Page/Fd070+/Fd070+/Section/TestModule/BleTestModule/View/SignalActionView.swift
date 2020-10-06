
//
//  SignalActionView.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/6/4.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

//SingleBtn枚举
enum SingleBtnAction:Int {

    case setPeronalInfo = 1000
    case getPersonalInfo
    case setWorkoutTarget
    case getWorktoutTarget

    case emptyTarget1

    case setCurrentTime
    case getCurrentTime
    case startOTA
    case factoryReset
    case deviceReset
    case openPairWindow
    case continuousHR

    case emptyTarget2

    case erasureFlash
    case getWorkoutData
    case getDailyData

    case emptyTarget3

    case startGlucoseCollect
    case stopGlucoseCollect
    case resultGlucoseCollect


}

//StressBtn枚举
enum StressBtnAction:Int{

    case Tag_BtnConnDiscoAction = 2000
    case Tag_BtnConnResetAction
    case Tag_BtnOTAStressAction
    case Tag_BtnMonkeyAction

}

//LdleBtn枚举
enum LdleBtnAction:Int{
    
    case Tag_BtnScanAction = 3000
    case Tag_BtnDisConnectAction
    case Tag_BtnCleanAction
    case Tag_BtnEndTestAction
    case Tag_BtnLockScreenAction
}

class SignalActionView: UIView {
    
    var button :UIButton?

    let colorArr=[
        1:UIColor.red,
        2:UIColor.orange,
        3:UIColor.green
    ]
    
    let singleArr = [
        "Set PersonInfo","Get PersonInfo","Set WorkoutTarget","Get WorkoutTarget","", "Set Current Time","Get Current Time", "Start OTA","Factory reset","Device reset"," open pair window","Continuous HR","","Erasure flash","get workout data","get daily data","","start Glucose collect", "stop Glucose collect","result Glucose"
    ]
    
    let stressArr = [
        "discon/conn","con/reset","OTA Stress","OTA Monkey"
    ]
    
    let ldleArr = [
        "Daily data summary","Detail date","Inserting sleep data","To break off","reconnection"
    ]
    
    let btnTest_width:CGFloat = SCREEN_WIDTH/2.0
    let btnTest_higth:CGFloat = 40

    //MARK:添加闭包传回按钮tag值
    var btnTagBlock: ((NSInteger) -> ())?

    
    //MARK:初始化枚举值
    var singleTag = SingleBtnAction.setPeronalInfo
    
    var stressTag = StressBtnAction.Tag_BtnConnDiscoAction
    
    var ldleTag = LdleBtnAction.Tag_BtnScanAction

    var number:Int = 1 {

        didSet {
            self.configUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)

        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configUI() {
        
        //根据传过来的number值，确定要使用的数据源
        let allCountArr = [
            1:singleArr.count,
            2:stressArr.count,
            3:ldleArr.count
        ]
        
        let allTitleArr = [
            1:singleArr,
            2:stressArr,
            3:ldleArr
        ]
        
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width:Int(SCREEN_WIDTH), height:300)
        scrollView.backgroundColor = colorArr[number]
        scrollView.bounces = false

        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSize(width:0,height:(allCountArr[number]! / 2 + 5) * Int(btnTest_higth))
        self.addSubview(scrollView)
        
        for i in 0..<allCountArr[number]!
        {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: btnTest_width, height: btnTest_higth)
            btn.backgroundColor = .gray

            btn.frame = CGRect(x: CGFloat((i%2) * Int(btnTest_width)), y: CGFloat((i/2) * Int(btnTest_higth)), width: btnTest_width, height: btnTest_higth)
            btn.layer.borderWidth = 1.0
            btn.layer.borderColor = UIColor.yellow.cgColor
            if number == 1{
                btn.tag = singleTag.rawValue + i
            }
            if number == 2 {
                btn.tag = stressTag.rawValue + i
            }
            if number == 3 {
                btn.tag = ldleTag.rawValue + i
            }
            let title = allTitleArr[number]![i] as String
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.addTarget(self, action: #selector(testBtnClick(sender:)), for: .touchUpInside)
            scrollView.addSubview(btn)
        }
    }
    
    
    //TODO:testBtnClick Click events
    @objc func testBtnClick(sender:UIButton) {

        //判断闭包,非空时,回调
        if self.btnTagBlock != nil {
            self.btnTagBlock!(sender.tag)
        }

    }


    
}
