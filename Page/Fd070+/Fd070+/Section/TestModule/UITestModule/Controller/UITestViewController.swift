
//
//  UITestViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/8.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class UITestViewController: UIViewController {

    var progressView: CircularProgressView!

    let donut = FDDonutView.init(frame: CGRect.init(x: 20, y: 74, width: 100, height: 100))
    let boodSugarDonutView = BloodSugarDonutView.init(frame: CGRect.init(x: 20, y: 74, width: 100, height: 100))

    let progressViewCell = MydayProgressView.init(frame: CGRect.init(x: 10, y: 84, width: 200, height: 200))
    //            progressView.backgroundColor = UIColor.randomColor

    let otaView = OtaUploadMaskView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))

    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = UIColor.white

        //        alertTest()


        //                progressTest()

//                progressViewCellTest()

                otaViewTest()

        //        bloodSugarMeasureViewTest()

        //        BoodSugarDonutViewTest()

//        donutViewTest()

        //        heartRateViewTest()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        FDCircularProgressLoadToolTest()

        //        layerTest()

        //        donut.endRotationAnimation()

        //        boodSugarDonutView.addIndicatorLayerAnimation()

    }

    func TELESTEST() {

        #if RELEASE

        print("Release")
        #else

        print("Other")
        #endif
    }

    func progressTest() {

        let width = (self.view.width) / 2
        let x = (self.view.width - width) / 2
        let y = (self.view.height - width) / 2

        progressView = CircularProgressView.init(frame: CGRect.init(x: x, y: y, width: width, height: width))
        progressView.isShowBGLayer = true

        progressView.mainColor = MainColor


        view.addSubview(progressView)

        let slider = UISlider.init()

        view.addSubview(slider)
        slider.addTarget(self, action: #selector(UITestViewController.change(slider:)), for: UIControlEvents.valueChanged)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-navigationBarHeight)
        }



    }



    func otaViewTest() {
        AppDelegate.getDelegate().window!.addSubview(self.otaView)
        self.otaView.changeOTaProgress(progress: 1)

        let slider = UISlider.init()
        AppDelegate.getDelegate().window?.insertSubview(slider, aboveSubview: otaView)

        slider.addTarget(self, action: #selector(UITestViewController.change(slider:)), for: UIControlEvents.valueChanged)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-navigationBarHeight)
        }
    }
    func progressViewCellTest() {

        view.addSubview(progressViewCell)

        let slider = UISlider.init()

        view.addSubview(slider)
        slider.addTarget(self, action: #selector(UITestViewController.change(slider:)), for: UIControlEvents.valueChanged)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-navigationBarHeight)
        }

    }

    @objc func change(slider:UISlider) {

        //                progressView.progress = CGFloat(slider.value)
        //        progressViewCell.strokeEndFloat = CGFloat(slider.value * 10)
//        donut.animateTo(percentage: CGFloat(slider.value))

        //    progressViewCell.progress = CGFloat(slider.value)

                self.otaView.changeOTaProgress(progress: Int(CGFloat(slider.value * 100)))

    }


    func alertTest() {

        AlertTool.showAlertView(title: "Title", message: "Message") { (index) in
            print(index)
        }
    }


    func FDCircularProgressLoadToolTest() {

        FDCircularProgressLoadTool.shared.show()
        //        FDCircularProgressLoadTool.shared.show(message: "Loading")
        //        FDCircularProgressLoadTool.shared.show(message: "Lodaing...", circulaColor: UIColor.yellow)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            FDCircularProgressLoadTool.shared.dismiss()
        }


    }

    func bloodSugarMeasureViewTest() {

        //        let bloodSugarMeasureView = BloodSugarMeasureView.init(frame: CGRect.init(x: 10, y: 74, width: 100, height: 100))
        //        view.addSubview(bloodSugarMeasureView)
    }

    func layerTest() {

        let rect = CGRect.init(x: Int.random(in: 10 ... 122), y: 74, width: 10, height: 80)

        let shl = CAShapeLayer()
        let b = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 5, height: 5))
        shl.path = b.cgPath
        shl.fillColor = UIColor.yellow.cgColor
        let an = FDAnimate.baseAnimationWithKeyPath("strokeEnd", fromValue: 0, toValue: 1, duration: 2, repeatCount: nil, timingFunction: nil)
        shl.add(an, forKey: nil)

        let layer = CALayer.init()
        layer.frame = rect
        layer.backgroundColor = UIColor.red.cgColor

        layer.mask = shl


        view.layer.addSublayer(layer)

        
    }

    func donutViewTest() {


        //        donut.baseColour = UIColor.blue.withAlphaComponent(0.1)
        //        donut.fromColour = UIColor.white
        //        donut.toColour = UIColor.blue
        //        donut.lineWidth = 30
        //        donut.duration = 1
        donut.layout()
        donut.animateTo(percentage: 0.65)
        donut.backgroundColor = UIColor.randomColor
        view.addSubview(donut)

        //        donut.startRotationAnimation()

        let slider = UISlider.init()

        view.addSubview(slider)
        slider.addTarget(self, action: #selector(UITestViewController.change(slider:)), for: UIControlEvents.valueChanged)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-navigationBarHeight)
        }

    }

    func BoodSugarDonutViewTest() {


        boodSugarDonutView.backgroundColor = UIColor.randomColor
        view.addSubview(boodSugarDonutView)

    }

    func heartRateViewTest() {

        let historyHeartRateChartsView = HistoryHeartRateChartsView.init(frame: CGRect.init(x: 0, y: 74, width: self.view.width, height: (SCREEN_HEIGHT * 2) / 3))
        historyHeartRateChartsView.model = HistoryHeartRateChartsManager.getHistoryHeartRateChartsModelFromDB()
        view.addSubview(historyHeartRateChartsView)
    }

}
