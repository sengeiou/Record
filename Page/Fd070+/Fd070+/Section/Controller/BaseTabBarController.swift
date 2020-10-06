//
//  BaseTabBarController.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/17.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configData()

    }

    private func configUI() {

        let myDayNavVC = setChildViewController(MydayViewController(), title: "Tabbar_today".localiz(), norImageName: "my_day", selImageName: "my_daysel", selectTag: 0)
        let workoutNavVC = setChildViewController(WorkoutViewController(), title: "Tabbar_exercise".localiz(), norImageName: "my_activity", selImageName: "my_activitysel", selectTag: 1)
//
        let historyNavVC = setChildViewController(HistoryViewController(), title: "Tabbar_history".localiz(), norImageName: "my_history", selImageName: "my_historysel", selectTag: 3)
        let myProfileNavVC = setChildViewController(MyProfileViewController(), title: "Tabbar_me".localiz(), norImageName: "my_me", selImageName: "my_mesel", selectTag: 4)
        
        let controllers = [myDayNavVC, workoutNavVC, historyNavVC, myProfileNavVC]
//         let controllers = [myDayNavVC, myProfileNavVC]
        self.setViewControllers(controllers, animated: false)
    }

    func configData() {

    }

    /// set child viewcontroller
    ///
    /// - Parameters:
    ///   - childController: child controller
    ///   - title: controller title
    ///   - norImageName: normal image name
    ///   - selImageName: selected image name
    ///   - selectTag: selected tag
    /// - Returns: wraped viewcontroller
    private func setChildViewController(_ childController: UIViewController, title: String, norImageName: String, selImageName: String, selectTag:NSInteger) -> BaseNavigationController {

        let norImage = UIImage(named: norImageName)
        childController.tabBarItem.image = norImage?.withRenderingMode(.alwaysOriginal)

        let selImage = UIImage(named: selImageName)
        childController.tabBarItem.selectedImage = selImage?.withRenderingMode(.alwaysOriginal)
        if selectTag == 2 {
            childController.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 0, 15, 0)
        }
        self.tabBar.tintColor = UIColor.black
        childController.tabBarItem.title = title

        let font = UIFont.systemFont(ofSize: 10)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        childController.tabBarItem.tag = selectTag

        return BaseNavigationController(rootViewController: childController)

    }
}
