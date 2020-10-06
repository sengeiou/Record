//
//  DeviceSelectDevcieViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/18.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class DeviceSelectDevcieViewController: BaseViewController {

    var deviceTypeView:SelectDeviceView = SelectDeviceView()
    var deviceGuideView:DeviceGuidView = DeviceGuidView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "DeviceSelectVC_title".localiz()

        // Do any additional setup after loading the view.
    }


    override func initDisplayData() {
        
    }
    
    override func initDisplayView() {

        deviceTypeView = SelectDeviceView.init(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-20))
        view.addSubview(deviceTypeView)
        
        deviceGuideView = DeviceGuidView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-navigationBarHeight))
        view.addSubview(deviceGuideView)
        self.view.sendSubview(toBack: deviceGuideView)
        
        self.view.bringSubview(toFront: deviceTypeView)
        
        deviceTypeView.didSelctCell = { (indexPath) in
            
            self.view.bringSubview(toFront: self.deviceGuideView)
        }
        
        deviceGuideView.didCleckBlock = {[unowned self] (tag) in
            
            switch tag {
            case deviceGuidBtnTag.startPairTag.rawValue:
                
                if BleConnectState.getSystemBleState() {
                    self.navigationController?.pushViewController(DeviceScanViewController(), animated: true)
                }
                else
                {

                    AlertTool.showAlertView(message: "TurnOnSystemBluetooth".localiz(), cancalTitle: "Cancel".localiz(), action: {
                        print("点击了取消按钮")
                    })
                }
                
                break
            case deviceGuidBtnTag.noPairTag.rawValue:
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.changeRootViewController()
                break
            default:
                break
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    

}
