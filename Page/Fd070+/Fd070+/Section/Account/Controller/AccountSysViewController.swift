//
//  AccountSysViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/11.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import WebKit


class AccountSysViewController: BaseViewController {
    
    
    fileprivate var accountWebView:WKWebView!
    
    fileprivate var loadingTimer:Timer?
    
    public var language:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func initDisplayView() {
        
        view.backgroundColor = UIColor.white
        
        //这里Y方向空的原因是Web页面有留白
        accountWebView = WKWebView.init(frame: CGRect.init(x: 0, y: -statusBarHeight, width: view.width, height: view.height))
        accountWebView.navigationDelegate = self
        accountWebView.uiDelegate = self
        accountWebView.load(URLRequest.init(url: URL(string: AccountInfoManager.accountSynUrl)!))
        
        self.loadingTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(loadingWebTimeOut), userInfo: nil, repeats: false)
        self.view.addSubview(accountWebView)
        self.startMaskAnimation(tipStr: "")
        
        
        
        
    }
    
    override func initDisplayData() {
        
    }
    
    
    @objc func loadingWebTimeOut() {
        
        self.stopMaskAnimation()
        self.loadingTimer?.invalidate()
        self.loadingTimer = nil
        accountWebView.stopLoading()
        
        AlertTool.showAlertView(title: "AccountSy_load_failure_tip".localiz(), message: "AccountSy_load_failure_message".localiz()) { (index) in
            if index == -1 {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.startMaskAnimation(tipStr: "")
                self.accountWebView.load(URLRequest.init(url: URL(string: AccountInfoManager.accountSynUrl)!))
                self.loadingTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.loadingWebTimeOut), userInfo: nil, repeats: false)
            }
        }
        
    }
}


extension AccountSysViewController:WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("已经加载完成")
        self.loadingTimer?.invalidate()
        self.loadingTimer = nil
        accountWebView.configuration.userContentController.add(self, name: AccountInfoManager.accountLoginCallBack)
        accountWebView.configuration.userContentController.add(self, name: AccountInfoManager.accountThirdLoginCallBack)
        
        self.stopMaskAnimation()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("已经开始加载")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("11111已经开始加载")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingTimer?.invalidate()
        self.loadingTimer = nil
        print("加载失败")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch message.name {
        case AccountInfoManager.accountLoginCallBack:
            if let loginDic:[String:String] = message.body as? [String : String] {
                
                AccountInfoManager.handleLoginInfo(loginDic) { (isSuccess) in
                    if isSuccess == true {
                        
                        print("FDCircularProgressLoadTool.shared.dismiss()  \(Thread.isMainThread)")
                        FDCircularProgressLoadTool.shared.show()
                        self.getDeviceAndUserInforFromServer()
                        return
                    }
                }
            }
        //            print("Login failure")
        case AccountInfoManager.accountThirdLoginCallBack:
            AccountInfoManager.handleThirdLogin(LoginType: loginThirdType(rawValue: message.body as! String) ?? .Idle)
            print("thirty party Login")
        default:
            print("other")
        }
    }
    
    fileprivate func getDeviceAndUserInforFromServer() {
        
        //Get userInformation
        UserInfoManager.downloadUserInformation(language: self.language ?? "中国") { (userModel, result) in
            
            var modelNew = userModel
            //更新地区设置
            modelNew.language = UserDefaults.ContryInfoKey.country.storedValue as? String ?? "0"
            modelNew.calculating = UserDefaults.ContryInfoKey.calculating.storedValue as? String ?? "1"
            
            //登录成功，获得了userId就可以创建数据库了
            self.createTables()
            
            try? UserinfoDataHelper.insertOrUpdate(items: [modelNew], complete: {[unowned self] in
                FDLog("Insert or update userInfo complete")
                DispatchQueue.main.async {
                    
                    let VC = NameViewController()
                    //判断是否是第一次登陆。之前的第一次登陆是要隐藏UINav的 Date:2-25
                    VC.isFirstLogin = true
                    VC.userModel = modelNew
                    //拉取必要的数据
                    NetworkDataSyncManager.login()

                    FDCircularProgressLoadTool.shared.dismiss()
                    self.navigationController?.pushViewController(VC, animated: true)
                }

            })
            
        }
    
    }
    
    fileprivate func createTables() {

        //切换用户数据库
        SQLiteDataStore.destroyInstance()
        SQLiteDataStore.reSetInstance()

        //Create Tables
        try? SQLiteDataStore.sharedInstance!.createTables()
        
        //Migrate if needed
        try? SQLiteDataStore.sharedInstance?.migrateIfNeeded()
        
        FDLog(SQLiteDataStore.sharedInstance?.description)
        
    }
}
