//
//  FDSleepDetailView.swift
//  FD070+
//
//  Created by WANG DONG on 2019/2/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class FDSleepDetailView: UIView {

    private let surfaceView:UIView = UIView() //蓝色背景
    private var sliderView:UIView = UIView() //滑块View

    let sleepStateIndicatorLayer = CALayer()

     var timeLabelArray = [UILabel]() //存放对应的时间label
    private var timeArray = [String]() //具体需要显示的时间

    //当前View的高度
    var viewHeight:CGFloat = 0
    //Label的高度 根据view自身的高度决定
    var labelHeight:CGFloat = 0
    //对应Label之间的间隔
    let labelIntervalWidth:CGFloat = 0
    //弧形控件的宽度
    let sliderViewWidth:CGFloat = 85.auto()
    //弧形控件的高度
    var sliderViewHeight:CGFloat = 45.auto()

    //弧形控件向上的偏移量
    var sliderOffsetHeight:CGFloat = 15.auto()


    var sleepDetailModel:FDSleepDetailSummaryModel = FDSleepDetailSummaryModel()

    var sleepMonthModel:FDSleepMonthSummaryModel = FDSleepMonthSummaryModel()

    /// 睡眠视图呈现的颜色:深睡、浅睡、清醒
     var sleepViewColor:[UIColor]?

    //区分不同的统计数据
     var sleepSummaryType:FDSleepDetailSummaryType?


    //滑动时的指示器
    let indicatorLayer = CAShapeLayer()

    private var heightUnite:CGFloat = 0 //移动时的高度单位
    private var centerXWidth:CGFloat = 0 //中心点之间的距离

    var descViewHeigth: CGFloat = 0

    var sleepDurationMax: CGFloat = 0

    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 15.auto())
        dateLabel.textColor = UIColor.white
        return dateLabel
    }()


    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: 32.auto())
        valueLabel.textColor = UIColor.white
        return valueLabel
    }()


    var deepSleepStateTextLayer: CATextLayer!
    var lightSleepStateTextLayer: CATextLayer!
    var soberStateTextLayer: CATextLayer!
    var isShowSliderView = true

    init(frame: CGRect, sleepModel:FDSleepDetailSummaryModel,viewColor:[UIColor]? = [UIColor.red,UIColor.yellow,UIColor.blue], isShowSliderView: Bool = true) {
        super.init(frame: frame)

        //属性赋值
        dateLabel.text = sleepModel.date
        valueLabel.text = FDSleepDetailManager.getSleepDuration(sleepModel.sleepDeepCount + sleepModel.sleepLightCount + sleepModel.sleepSoberCount)
        //显示睡眠详情数据View的高
        descViewHeigth = self.height * 0.35

        viewHeight = frame.height
        labelHeight = 20

        self.isShowSliderView = isShowSliderView
        if isShowSliderView == false {
            sliderOffsetHeight = 0
            labelHeight = 0
            sliderViewHeight = 0
        }

        self.sleepSummaryType = .day
        self.sleepDetailModel = sleepModel
        self.sleepViewColor = viewColor

        self.displayViewViewInit(type: self.sleepSummaryType!)
    }


    init(frame: CGRect, sleepModel:FDSleepMonthSummaryModel,viewColor:[UIColor]? = [UIColor.red,UIColor.yellow,UIColor.blue], summaryType: FDSleepDetailSummaryType) {
        super.init(frame: frame)

        dateLabel.text = sleepModel.month
        valueLabel.text = FDSleepDetailManager.getSleepDuration(sleepModel.sleepDeepTotal + sleepModel.sleepLightTotal + sleepModel.sleepsoberTotal)

        descViewHeigth = self.height * 0.35

        let maxYModel = sleepModel.sleepValues.max(by: { (model0, model1) -> Bool in
            let model0SleepDuration = model0.sleepDeepTotal + model0.sleepLightTotal + model0.sleepsoberTotal
            let model1SleepDuration = model1.sleepDeepTotal + model1.sleepLightTotal + model1.sleepsoberTotal
            return model0SleepDuration < model1SleepDuration
        }) ?? FDSleepDayDetailModel()

        let maxYvalue = maxYModel.sleepDeepTotal + maxYModel.sleepLightTotal + maxYModel.sleepsoberTotal

        let ratio = getSleepRatio(maxYvalue)
        let step = ((Int(maxYvalue) / 4 / Int(ratio)) + 1) * Int(ratio)
        sleepDurationMax = CGFloat(step * 4)

        self.sleepSummaryType = summaryType
        viewHeight = frame.height
        labelHeight = 20
        self.sleepMonthModel = sleepModel
        self.sleepViewColor = viewColor

        self.displayViewViewInit(type: self.sleepSummaryType!)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
// MARK: - Must imp func
extension FDSleepDetailView {

    func displayViewViewInit(type:FDSleepDetailSummaryType) {

        setContentView()

        drawIndicator()
        drawSleepAbscissa()

        switch type {
        case .day:
            self.displaySleepDetailView()
        case .month:
            self.displaySleepMonthView()
        case .year:
            self.displaySleepYearView()
        }

        //初始化视图时未放在父视图中央。处理坐标点使其在中央。
        var centerX = self.center.x
        if centerX < 0 {
            centerX = -centerX
        }else {
            centerX = centerX / 3
        }
        let center = CGPoint.init(x: centerX, y: self.center.y)
        //默认滑动到的位置
        handleSliderPointView(point: center)


        addChartDescriptionView()
        addsleepStateIndicatorLayer()


    }

    private func setContentView() {

        self.backgroundColor = UIColor.white


        //放置图表和顶部图表值的View
        surfaceView.backgroundColor = MainColor
        //        surfaceView.backgroundColor = UIColor.randomColor
        surfaceView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: viewHeight-sliderOffsetHeight)
        self.addSubview(surfaceView)

        if isShowSliderView == false {
            return
        }

        //滑动有波浪效果的View
        sliderView = UIView(frame: CGRect(x: 0, y: viewHeight - sliderViewHeight, width: CGFloat(Int(sliderViewWidth)), height: sliderViewHeight))
        sliderView.backgroundColor = UIColor.white
        //sliderView抗锯齿
        sliderView.layer.borderWidth = 3;
        sliderView.layer.borderColor =  UIColor.clear.cgColor
        sliderView.layer.shouldRasterize = true
        sliderView.layer.rasterizationScale = UIScreen.main.scale
        self.addSubview(sliderView)

        //波浪的View
        let waveView = UIView(frame: CGRect(x: 0, y: 0, width: sliderViewWidth, height: sliderViewHeight))
        waveView.backgroundColor = MainColor
        sliderView.addSubview(waveView)

        //圆形背景
        let arcCenter = CGPoint.init(x: sliderViewWidth / 2, y: (sliderViewHeight / 2) + 8.auto())

        let beadShapeLayer = CAShapeLayer()
        let beadShapeLayerRadius: CGFloat = sliderViewHeight * 0.45
        beadShapeLayer.fillColor = UIColor.RGB(r: 213, g: 233, b: 255).cgColor
        beadShapeLayer.path = UIBezierPath.init(arcCenter: arcCenter, radius: beadShapeLayerRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi) , clockwise: true).cgPath
        sliderView.layer.addSublayer(beadShapeLayer)

        //圆形背景中的小圆点
        let centShapeLayer = CAShapeLayer()
        let centShapeLayerRadius: CGFloat = sliderViewHeight * 0.1
        centShapeLayer.fillColor = UIColor.RGB(r: 16, g: 121, b: 228).cgColor
        centShapeLayer.path = UIBezierPath.init(arcCenter: arcCenter, radius: centShapeLayerRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi) , clockwise: true).cgPath
        beadShapeLayer.addSublayer(centShapeLayer)

        //波浪的Layer
        let waveMask = FDWaveLayer(waveARCHeight: sliderViewHeight/2, waveARCWidth: sliderViewWidth, sideHeight: sliderOffsetHeight)
        waveMask.frame = waveView.bounds
        waveMask.updatePath()
        waveView.layer.mask = waveMask

        //最底部XValue的Label.滑动有波浪效果的

        switch sleepSummaryType {
        case .day?:
            timeArray = ["20:00","00:00","04:00","08:00","12:00","16:00"]
        case .month?:
            timeArray = ["1/1","1/8","1/15","1/22","11/29"]
        case .year?:
            timeArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        case .none:
            break
        }

        //在原来的基础上再减30. 让出最右边Label的距离
        let timeLabelWidth:CGFloat = (SCREEN_WIDTH - CGFloat(timeArray.count+1)*labelIntervalWidth - 30)/CGFloat(timeArray.count)

        self.centerXWidth = (timeLabelWidth/2 + sliderViewWidth/2)
        self.heightUnite = CGFloat(sliderViewHeight - sliderOffsetHeight)/self.centerXWidth

        for i in 0..<timeArray.count {
            let timeLabel = UILabel(frame: CGRect(x: CGFloat(i)*(timeLabelWidth+labelIntervalWidth) + labelIntervalWidth, y: viewHeight - sliderOffsetHeight - labelHeight, width: timeLabelWidth, height: labelHeight))
            timeLabel.textAlignment = .center
            timeLabel.textColor = UIColor.white
            timeLabel.text = timeArray[i]
            timeLabel.font = UIFont.systemFont(ofSize: 13.auto())
            self.addSubview(timeLabel)
            //                        timeLabel.backgroundColor = UIColor.randomColor
            timeLabelArray.append(timeLabel)
        }

    }


}

// MARK: - Day detail data
extension FDSleepDetailView {

    func displaySleepDetailView() {

        let startTime = self.sleepDetailModel.sleepStart
        let endTime = self.sleepDetailModel.sleepEnd
        let minutsUnitX = (SCREEN_WIDTH - sliderViewWidth)/CGFloat((endTime-startTime + 1)/60)
        let awakeBasicY = viewHeight-sliderViewHeight-labelHeight
        let sleepHeight = (awakeBasicY-descViewHeigth)/3

        for i in 0 ..< self.sleepDetailModel.values.count {

            var item = self.sleepDetailModel.values[i]

            let sleepLayer:CALayer = CALayer()


            let startTemX = sliderViewWidth/2 + CGFloat((item.sleepStartTime - startTime)/60) * minutsUnitX
            let widthTem = CGFloat(item.sleepEndTime - item.sleepStartTime)/60 * minutsUnitX

            switch item.sleepType {
            case .deep?:
                sleepLayer.frame = CGRect(x: startTemX, y: awakeBasicY-sleepHeight, width: widthTem, height: sleepHeight)
                sleepLayer.backgroundColor = self.sleepViewColor![2].cgColor
                break
            case .light?:
                sleepLayer.frame = CGRect(x: startTemX, y: awakeBasicY-sleepHeight * 2, width: widthTem, height: sleepHeight)
                sleepLayer.backgroundColor = self.sleepViewColor![1].cgColor
                break
            case .sober?:
                sleepLayer.frame = CGRect(x: startTemX, y: awakeBasicY - sleepHeight * 3, width: widthTem, height: sleepHeight)
                sleepLayer.backgroundColor = self.sleepViewColor![0].cgColor
                break
            default:
                break
            }

            item.sleepStartX = startTemX
            item.sleepEndX = startTemX + widthTem
            item.sleepLayer = sleepLayer
            item.originalColor = sleepLayer.backgroundColor!
            self.sleepDetailModel.values[i] = item
            self.layer.addSublayer(sleepLayer)
        }
    }
}
// MARK: - Touch event handle
extension FDSleepDetailView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorLayer.isHidden = false
        let point = touches.first?.location(in: self)

        self.handleSliderPointView(point: point!)

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorLayer.isHidden = false
        let point = touches.first?.location(in: self)

        self.handleSliderPointView(point: point!)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorLayer.isHidden = true
        let point = touches.first?.location(in: self)

        self.handleSliderPointView(point: point!)

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorLayer.isHidden = true
        print("touchesCancelled")

    }

    func handleSliderPointView(point:CGPoint) {

        if  point.x < sliderViewWidth/6 || point.x > SCREEN_WIDTH-sliderViewWidth/6 {
            return
        }

        self.sliderView.centerX = point.x


        indicatorLayer.frame.origin.x = point.x

        let labelCenterY:CGFloat = self.sliderView.frame.maxY - sliderOffsetHeight - labelHeight/2

        for label in self.timeLabelArray {


            let isChangeCenterY = (self.sliderView.frame.minX <= label.frame.maxX &&  self.sliderView.frame.minX >= label.frame.minX) || //判断左边进入的Label
                (self.sliderView.frame.maxX <= label.frame.maxX &&  self.sliderView.frame.maxX >= label.frame.minX) ||                  //判断右边进入的label
                (self.sliderView.frame.minX <= label.frame.minX && self.sliderView.frame.maxX >= label.frame.maxX)                     //判断落在弧形区域内的Label

            if isChangeCenterY {

                label.centerY = labelCenterY - (self.centerXWidth - CGFloat(fabsf(Float(label.centerX - point.x))))*self.heightUnite
                continue
            }

            if self.sliderView.frame.maxX < label.frame.minX || self.sliderView.frame.minX > label.frame.maxX {
                label.centerY = labelCenterY
            }

        }

        
        switch self.sleepSummaryType! {
        case .day:
            for item in self.sleepDetailModel.values {

                if point.x >= item.sleepStartX && point.x <= item.sleepEndX {
                    item.sleepLayer.backgroundColor = UIColor.cyan.cgColor
                    continue
                }

                item.sleepLayer.backgroundColor = item.originalColor
            }
            break
        case .month, .year:
            for item in self.sleepMonthModel.sleepValues {

                let itemLayerX = (item.sleepLayer?.x) ?? 0
                let itemLayerRight = (item.sleepLayer?.right) ?? 0
                if point.x >=  itemLayerX && point.x <= itemLayerRight {
                    showMonthAndYearSleepDurationString(item)
                    continue
                }
            }

        }

    }

    private func showMonthAndYearSleepDurationString(_ sleepDayDetailModel: FDSleepDayDetailModel) {

        guard let _ = soberStateTextLayer else {
            return
        }

        soberStateTextLayer.string = FDSleepDetailManager.getSleepDuration(sleepDayDetailModel.sleepsoberTotal)
        lightSleepStateTextLayer.string = FDSleepDetailManager.getSleepDuration(sleepDayDetailModel.sleepLightTotal)
        deepSleepStateTextLayer.string = FDSleepDetailManager.getSleepDuration(sleepDayDetailModel.sleepDeepTotal)
    }
}

