//
//  BleTestViewController.swift
//  Orangetheory
//
//  Created by WANG DONG on 2018/6/19.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit
import SnapKit
import FendaBLESwiftLib
import CoreBluetooth

class BleTestViewController: BaseViewController {
    
    
    fileprivate struct Constant {
        
        static let funcionBtnHeight: CGFloat = 40
        static let defaultHeight: CGFloat = 90.0
        static let minHeight: CGFloat = 50.0
        
        static let funcionBtnTitles: Array = ["Search","DisCon","Clean","Stop","Unlock"]
    }
    
    fileprivate  let textView = UITextView().then {
        $0.backgroundColor = .lightGray
        $0.isSelectable = false
    }
    
    fileprivate var signalActionView = SignalActionView().then {
        $0.number = 1
    }
    
    fileprivate var segmented = UISegmentedControl()
    fileprivate let testManager = TestManager()
    
    var deviceView:BleDeviceListView! = nil
    var bleConnectManager:BleOperatorManager! = nil
    private var peripheralsArray:NSArray = NSArray.init()
    private var peripheralMacDic:NSDictionary = NSDictionary.init()
    private var peripheralNameDic:NSDictionary = NSDictionary.init()
    private var peripheralRssiDic:NSDictionary = NSDictionary.init()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configUI()
        bindUI()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func configUI() {

        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBarHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }


        var funcionBtnArr = [UIButton]()
        for funcionBtnTitle in Constant.funcionBtnTitles {
            let btn = UIButton()
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle(funcionBtnTitle, for: .normal)
            btn.layer.borderWidth = 1
            
            btn.addTarget(self, action: #selector(funcionBtnClick(sender:)), for: .touchUpInside)
            view.addSubview(btn)
            funcionBtnArr.append(btn)
        }
        funcionBtnArr.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        funcionBtnArr.snp.makeConstraints{
            $0.top.equalTo(textView.snp.bottom)
            $0.height.equalTo(Constant.funcionBtnHeight)
        }
        
        let items:Array = ["Single","Stress","Ldle"]
        segmented = UISegmentedControl.init(items: items)
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segmentedControlChanged), for: UIControlEvents.valueChanged)
        view.addSubview(segmented)
        segmented.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(Constant.funcionBtnHeight)
            make.height.equalTo(Constant.funcionBtnHeight)
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        signalActionView.btnTagBlock = { [unowned self] testBtnTag in
            
            self.testManager.testItem(testBtnTag)
        }
        view.addSubview(signalActionView)
        signalActionView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(Constant.funcionBtnHeight * 2)
            make.left.right.bottom.equalTo(view)
        }
        
        self.deviceView = BleDeviceListView.init(frame: CGRect.init(x: 0, y: navigationBarHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.deviceView.selectConnectDevice = {(selectPeripheral)in
            self.bleConnectManager.connectSelectPeripheral(peripheral: selectPeripheral)
        }
        
    }
    
    //TODO:UISegmentedControl Click events
    @objc func segmentedControlChanged(sender:UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            signalActionView.number = 1
            
        case 1:
            
            signalActionView.number = 2
            
        case 2:
            
            signalActionView.number = 3
            
        default:
            print("default")
        }
    }
    
    //TODO:Funcion Button Click events
    @objc func funcionBtnClick(sender:UIButton) {
        
        switch sender.title(for: .normal){
        case "Search":
            print("Search")
        case "DisCon":
            
            self.bleConnectManager.disConnectCertainPeripheral(isAutoReconnect: false)
            
        case "Clean":
            
            self.textView.text = ""
            
        case "Stop":
            
            print("Stop")
            
        case "Unlock":
            
            print("Unlock")
            
        default:
            print("default")
        }
    }
    
    
    private func bindUI() {
        
        
        bleConnectManager = BleOperatorManager.instance
        
        self.bleConnectManager.logBlockProperty = {(logStr)in
            DispatchQueue.main.async {
                self.textView.text = self.textView.text.appending(String.init(format: "%@\n", logStr))
                self.textView.layoutManager.allowsNonContiguousLayout = false
                self.textView.scrollRangeToVisible(NSRange.init(location: self.textView.text.count, length: 1))
                
            }
        }
        
        bleConnectManager.realTimeUpdateScanOriginalBlock = {(peripheral , advertisementData ,RSSI) in
            DispatchQueue.main.async {
                let logStr = peripheral.name ?? "NO NAME"
                self.textView.text = self.textView.text.appending(String.init(format: "%@\n", logStr))
                self.textView.layoutManager.allowsNonContiguousLayout = false
                self.textView.scrollRangeToVisible(NSRange.init(location: self.textView.text.count, length: 1))
            }
        }
        
    }
}
