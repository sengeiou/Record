//
//  HistroySportChartsView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/13.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class HistorySportChartsView: UIView {
    
    private struct Constant {
        
        static let chartDescriptionViewHeigth: CGFloat = 50.auto()
        static let bottomBGLayerHeight: CGFloat = 15.auto()
        
        static let margin:CGFloat = 30
        
        static let xValuesLayerHeight: CGFloat = 50.auto()
        static let textHeight: CGFloat = 30.auto()
        static let yValuesWidth: CGFloat = 45.auto()

        
        static let indicatorTextLayerWidth: CGFloat = 65.auto()
        static let indicatorTextLayerHeight: CGFloat = 25.auto()
        
        //运动项目的主题色值
        static let walkFillColor = UIColor.RGB(r: 0, g: 211, b: 198)
        static let percentFillColor = UIColor.RGB(r: 242, g: 103, b: 163)
        static let distanceFillColor = UIColor.RGB(r: 85, g: 180, b: 253)
        static let sportTimeFillColor = UIColor.RGB(r: 104, g: 129, b: 255)
        static let calorieFillColor = UIColor.RGB(r: 255, g: 218, b: 0)

        static let mainBGColor = UIColor.RGB(r: 0, g: 125, b: 255)
        
        //弧形控件的宽度
        static let sliderViewWidth: CGFloat = 85.auto()
        //弧形控件的高度
        static let sliderViewHeight: CGFloat = 45.auto()
        //弧形控件向上的偏移量
        static let sliderOffsetHeight: CGFloat = 15.auto()
    }
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 15.auto())
        dateLabel.textColor = UIColor.white
        return dateLabel
    }()
    
    
    private lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: 32.auto())
        valueLabel.textColor = UIColor.white
        return valueLabel
    }()
    
    private lazy var unitLabel: UILabel = {
        let unitLabel = UILabel()
        unitLabel.font = UIFont.systemFont(ofSize: 20.auto())
        unitLabel.textColor = UIColor.white
        return unitLabel
    }()
    
    private let charsLayer = CALayer()
    private let xValuesLayer = CALayer()
    private let indicatorLineLayer = CAShapeLayer()
    private var indicatorTextLayer = CATextLayer()
    private var xValueTextLayers = [CATextLayer]()
    //固定其Y坐标值 3.4
    private var indicatorTextLayerY: CGFloat = 0

    private var fillColor = UIColor.clear
    private var pillarItems = [PillarItem]()

    var sliderLayer = CALayer() //滑块Layer
    private var heightUnite:CGFloat = 0 //移动时的高度单位
    private var centerXWidth:CGFloat = 0 //中心点之间的距离

    private var maxYValueWithScale = 0

    var model: HistorySportChartsModel = HistorySportChartsModel() {
        didSet {
            self.setData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setData() {
        
        //        self.layer.backgroundColor = UIColor.randomColor.cgColor
        dateLabel.text = model.date

        //步数必须是整数
        if model.type == .walk {

            var stepStr = model.value
            if stepStr.contains(".") {
                stepStr = String(stepStr.dropLast())
                stepStr = String(stepStr.dropLast())
            }
            //加个空格。防止因为斜字体被切割
            valueLabel.text = stepStr + " "
        }else {
            //加个空格。防止因为斜字体被切割
            valueLabel.text = model.value + " "
        }

        unitLabel.text = model.unit
        
        prepareDrawCharts()
    }
    private func configUI() {
        
        let chartDescriptionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: Constant.chartDescriptionViewHeigth))
        //        chartDescriptionView.backgroundColor = UIColor.randomColor
        addSubview(chartDescriptionView)
        
        chartDescriptionView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
        }
        
        chartDescriptionView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        chartDescriptionView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(valueLabel.snp.right)
            make.bottom.equalTo(valueLabel)
        }
        
    }
    private func prepareDrawCharts() {
        
        
        addContentViewCharts()
        
        switch model.type {
        case .walk:
            fillColor = Constant.walkFillColor
        case .target:
            fillColor = Constant.percentFillColor
        case .sportTime:
            fillColor = Constant.sportTimeFillColor
        case .calorie:
            fillColor = Constant.calorieFillColor
        case .distance:
            fillColor = Constant.distanceFillColor
        default:
            break
            
        }

        drawSportCharts(fillColor)
        
        addWaveLayer()
        drawXValues()
        
        //初始化视图时未放在父视图中央。处理坐标点使其在中央。
        var centerX = self.center.x
        if centerX < 0 {
            centerX = -centerX
        }else {
            centerX = centerX / 3
        }
        let center = CGPoint.init(x: centerX, y: self.center.y)
        //默认滑动到的位置
        handleSliderPointView(center)
    }
}
// MARK: - WaveLayer
extension HistorySportChartsView {
    
    private func addWaveLayer() {
        
        sliderLayer.frame = CGRect(x: 0, y: xValuesLayer.height - Constant.sliderViewHeight, width:CGFloat(Int(Constant.sliderViewWidth)), height: Constant.sliderViewHeight)
        sliderLayer.backgroundColor = UIColor.white.cgColor
        
        //sliderLayer抗锯齿
        sliderLayer.shouldRasterize = true
        sliderLayer.rasterizationScale = UIScreen.main.scale

        xValuesLayer.addSublayer(sliderLayer)
        
        let waveMaskBGLayer = CALayer()
        waveMaskBGLayer.frame = CGRect(x: 0, y: 0, width: Constant.sliderViewWidth, height: Constant.sliderViewHeight)
        
        waveMaskBGLayer.backgroundColor = Constant.mainBGColor.cgColor
        
        sliderLayer.addSublayer(waveMaskBGLayer)
        
        let waveMask = FDWaveLayer(waveARCHeight: Constant.sliderViewHeight/2, waveARCWidth: Constant.sliderViewWidth, sideHeight: Constant.sliderOffsetHeight)
        waveMask.frame = waveMaskBGLayer.bounds
        //                waveMask.backgroundColor = UIColor.blue.cgColor
        waveMask.backgroundColor = UIColor.clear.cgColor
        waveMask.updatePath()
        waveMaskBGLayer.mask = waveMask

        //圆形背景
        let arcCenter = CGPoint.init(x: Constant.sliderViewWidth / 2, y: (Constant.sliderViewHeight / 2) + 8.auto())

        let beadShapeLayer = CAShapeLayer()
        let beadShapeLayerRadius: CGFloat = Constant.sliderViewHeight * 0.45
        beadShapeLayer.fillColor = UIColor.RGB(r: 213, g: 233, b: 255).cgColor
        beadShapeLayer.path = UIBezierPath.init(arcCenter: arcCenter, radius: beadShapeLayerRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi) , clockwise: true).cgPath
        sliderLayer.addSublayer(beadShapeLayer)

        //圆形背景中的小圆点
        let centShapeLayer = CAShapeLayer()
        let centShapeLayerRadius: CGFloat = Constant.sliderViewHeight * 0.1
        centShapeLayer.fillColor = UIColor.RGB(r: 16, g: 121, b: 228).cgColor
        centShapeLayer.path = UIBezierPath.init(arcCenter: arcCenter, radius: centShapeLayerRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi) , clockwise: true).cgPath
        beadShapeLayer.addSublayer(centShapeLayer)


    }
    
    
    func handleSliderPointView(_ point:CGPoint) {
        
        if  point.x < Constant.sliderViewWidth / 2 || point.x > SCREEN_WIDTH - Constant.sliderViewWidth / 2 {
            return
        }
        
        self.sliderLayer.centerX = point.x
        let labelCenterY:CGFloat = self.sliderLayer.frame.maxY - Constant.sliderOffsetHeight - Constant.textHeight/2
        
        for label in self.xValueTextLayers {
            let isChangeCenterY = (self.sliderLayer.frame.minX <= label.frame.maxX &&  self.sliderLayer.frame.minX >= label.frame.minX) || //判断左边进入的Label
                (self.sliderLayer.frame.maxX <= label.frame.maxX && self.sliderLayer.frame.maxX >= label.frame.minX) ||                  //判断右边进入的label
                (self.sliderLayer.frame.minX <= label.frame.minX && self.sliderLayer.frame.maxX >= label.frame.maxX)                     //判断落在弧形区域内的Label
            
            if isChangeCenterY {
                
                label.centerY = labelCenterY - (self.centerXWidth - CGFloat(fabsf(Float(label.centerX - point.x))))*self.heightUnite
                
                continue
            }
            
            if self.sliderLayer.frame.maxX < label.frame.minX || self.sliderLayer.frame.minX > label.frame.maxX {
                label.centerY = labelCenterY
            }
            
        }
        
    }
}
// MARK: - Touch Handle
extension HistorySportChartsView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        handleTouchEvents(touches, event: event)
        indicatorLineLayer.isHidden = false
        indicatorTextLayer.isHidden = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches, event: event)
        indicatorLineLayer.isHidden = false
        indicatorTextLayer.isHidden = false


    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches, event: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.indicatorLineLayer.isHidden = true
            self.indicatorTextLayer.isHidden = true
        }
        
    }
    
    fileprivate func handleTouchEvents(_ touches: Set<UITouch>, event: UIEvent?) {
        
        if (self.model.values.isEmpty) {
            return
        }
        
        guard let _ = event else {
            return
        }
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in:self)
        let charsLayerPoint = self.layer.convert(point, to: charsLayer)
        let xValuesLayerPoint = xValuesLayer.convert(charsLayerPoint, from: charsLayer)
        
        //判断事件是否作用到xValuesLayer上
        if !xValuesLayer.contains(xValuesLayerPoint) {
            return
        }
        
        if charsLayerPoint.x < 0 || charsLayerPoint.x > SCREEN_WIDTH - (Constant.margin / 2) {
            return
        }
        
        handleSliderPointView(charsLayerPoint)
        handleSportTouchEvents(charsLayerPoint)
        
    }
    
    
    /// Hanlde sport touch events
    ///
    /// - Parameter point: The touch point
    func handleSportTouchEvents(_ point: CGPoint) {
        
        for (index, item) in pillarItems.enumerated() {
            if (item.path.bounds.minX < point.x) && (item.path.bounds.maxX > point.x) {
                let chartslayerFrame = charsLayer.convert(item.path.bounds, to: charsLayer)
                //固定Text指示器的Y坐标
                indicatorTextLayer.position.x = chartslayerFrame.midX
                let yValue = model.values[index].yValue.description


                if model.type == .walk, yValue.contains(".") {
                    indicatorTextLayer.string = String(yValue.dropLast().dropLast())

                }else if model.type == .calorie {
                    indicatorTextLayer.string = HistorySportChartsManager.coverCalorieValue(calorie: yValue).0
                }else if model.type == .distance {
                    indicatorTextLayer.string = HistorySportChartsManager.coverDistanceValue(distance: yValue).0
                }else if model.type == .sportTime {
                    indicatorTextLayer.string = HistorySportChartsManager.setTimeDuration(yValue)
                }else {
                    indicatorTextLayer.string = yValue
                }

                //                indicatorLineLayer.position.x = chartslayerFrame.midX
                indicatorLineLayer.frame.origin.x = chartslayerFrame.midX
                break
            }
        }
    }
}

// MARK: - Public
extension HistorySportChartsView {
    func drawXValues() {
        
        var textLayerStrArr = [String]()
        
        switch model.summaryType {
        case .day:
            textLayerStrArr = ["00:00", "06:00", "12:00", "18:00", "00:00"]
            
        case .month:
            let currentMonth = model.date.components(separatedBy: "/").last ?? "1"
            let monthCom = currentMonth + "/"

            var lastDayMonthStr = "29"
            //闰年的2月是28天
            if model.values.count == 28 {
                lastDayMonthStr = "28"
            }

            textLayerStrArr = [monthCom + "1", monthCom + "8", monthCom + "15", monthCom + "22", monthCom + lastDayMonthStr]
            
        case .year:
            textLayerStrArr = ["1","2","3","4","5","6","7","8","9","10","11","12"]
            
        }
        
        let textTotalWidth = charsLayer.bounds.maxX - Constant.yValuesWidth
        let textScale = (textTotalWidth) /  CGFloat(textLayerStrArr.count)
        
        //设置textLayer的升级高度
        self.centerXWidth = (textScale + Constant.sliderViewWidth/2)
        self.heightUnite = (CGFloat(Constant.sliderViewHeight - Constant.sliderOffsetHeight)/self.centerXWidth)
        
        for i in 0 ..< textLayerStrArr.count {
            
            
            let textX = (Constant.margin / 4) + CGFloat(i) * textScale
            let textRect = CGRect.init(x: textX, y: xValuesLayer.height - Constant.textHeight, width: textScale, height: Constant.textHeight)
            let textLayer = getTextLayer(frame: textRect, string: textLayerStrArr[i], size: 13.auto())
            
            xValuesLayer.addSublayer(textLayer)
            xValueTextLayers.append(textLayer)
        }
        
    }
    
    private func addContentViewCharts() {
        
        self.layer.backgroundColor = Constant.mainBGColor.cgColor
        
        //图表的Layer(包括图表、Y轴、Y轴上的Yvalue)
        charsLayer.frame = CGRect.init(x: Constant.margin / 4, y: Constant.chartDescriptionViewHeigth + 8.auto(), width: self.width - Constant.margin / 2, height: self.height - Constant.chartDescriptionViewHeigth - Constant.xValuesLayerHeight - Constant.bottomBGLayerHeight)
        charsLayer.backgroundColor = Constant.mainBGColor.cgColor
        //                charsLayer.backgroundColor = UIColor.randomColor.cgColor
        layer.addSublayer(charsLayer)
        
        //最底部哪个一条条的白色背景的Layer. 小圆球的白色填充色
        let bottomBGLayer = CALayer()
        bottomBGLayer.backgroundColor = UIColor.white.cgColor
        //                bottomBGLayer.backgroundColor = UIColor.red.cgColor
        bottomBGLayer.frame = CGRect.init(x: 0, y: self.height - Constant.bottomBGLayerHeight, width: self.width, height: Constant.bottomBGLayerHeight)
        layer.addSublayer(bottomBGLayer)
        
        //放X轴数据的Layer(包括滑动动画的Layer)
        xValuesLayer.frame = CGRect.init(x: 0, y: charsLayer.bottom, width: self.width, height: Constant.xValuesLayerHeight)
        xValuesLayer.backgroundColor = Constant.mainBGColor.cgColor
        //                xValuesLayer.backgroundColor = UIColor.yellow.cgColor
        
        layer.addSublayer(xValuesLayer)
        
        //滑动底部哪个长方体的背景Layer
        let sliderBGLayer = CALayer()
        //                sliderBGLayer.backgroundColor = UIColor.blue.cgColor
        sliderBGLayer.backgroundColor = UIColor.white.cgColor
        sliderBGLayer.frame = CGRect.init(x: 0, y: Constant.xValuesLayerHeight - Constant.bottomBGLayerHeight, width: self.width, height: Constant.bottomBGLayerHeight)
        xValuesLayer.addSublayer(sliderBGLayer)
        
        
    }
}

// MARK: - Factory func
extension HistorySportChartsView {
    
    func getTextLayer(frame: CGRect, string: String, size: CGFloat) ->CATextLayer {
        
        let textLayer = FDVerticalCenterTextLayer()
        textLayer.frame = frame
        textLayer.position = CGPoint.init(x: frame.midX, y: frame.midY)
        textLayer.contentsScale = UIScreen.main.scale
        
        let font = UIFont.systemFont(ofSize: size)
        textLayer.font = CGFont.init(font.fontName as CFString)
        textLayer.fontSize = font.pointSize
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.string = string
        //        textLayer.backgroundColor = UIColor.randomColor.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.preferredFrameSize()

        return textLayer
    }
}
extension HistorySportChartsView {
    
    func drawSportCharts(_ color: UIColor) {
        
        drawSportAbscissaAndYLabels()
        drawSportPillar(color)
        drawSportIndicatorShapeLayer(color)
        drawSportIndicatorTextLayer(color)
    }
    
    private func drawSportAbscissaAndYLabels() {
        
        let layTopY: CGFloat = 0
        let layerX: CGFloat = 0
        let layerWidth = charsLayer.width
        let layerHeight: CGFloat = 0.5
        let layerScale = (charsLayer.bounds.maxY - 1) / CGFloat(4)
        
        let textWidth: CGFloat = Constant.yValuesWidth
        let textHeight: CGFloat = Constant.textHeight
        let textX = charsLayer.bounds.maxX - textWidth
        
        let textDataSource = getYValues()
        
        for i in 0 ... 4 {

            //这个是从上往下画的
            let lineLayer = CALayer()
            let layerY = layTopY + CGFloat(i) * layerScale
            if i == 1 {
                //设置Text指示器的Y坐标
                indicatorTextLayerY = layerY
            }
            let layerRect = CGRect.init(x: layerX, y: layerY, width: layerWidth, height: layerHeight)
            lineLayer.frame = layerRect
            lineLayer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
            charsLayer.addSublayer(lineLayer)
            
            let textY = layerY - textHeight
            let textRect = CGRect.init(x: textX, y: textY, width: textWidth, height: textHeight)
            let textLayer = getTextLayer(frame: textRect, string: textDataSource[safe:i] ?? "", size: 15.auto())
            textLayer.alignmentMode = kCAAlignmentRight
            charsLayer.addSublayer(textLayer)
        }
        
        
        //Add goal layer
        let goalLayer = CALayer.init()
        goalLayer.frame = CGRect.init(x: 0, y: (charsLayer.bounds.maxY) / 3, width: layerWidth, height: layerScale)
        goalLayer.backgroundColor = UIColor.clear.cgColor
        
        let textLayer = getTextLayer(frame: CGRect.init(x: goalLayer.frame.width - Constant.yValuesWidth, y: 0, width: Constant.yValuesWidth, height: 10), string: "600", size: 23.auto())
        //        textLayer.backgroundColor = UIColor.yellow.cgColor
        goalLayer.addSublayer(textLayer)
        
        let lineLayer = CALayer()
        lineLayer.frame = CGRect.init(x: 0, y: textLayer.frame.height, width: goalLayer.frame.width, height: 0.5)
        lineLayer.backgroundColor = UIColor.RGB(r: 111, g: 178, b: 85).cgColor
        goalLayer.addSublayer(lineLayer)
        
        //MARK: 添加目标
        //        charsLayer.addSublayer(goalLayer)
        
    }
    
    private func getYValues() ->[String] {

        if model.type == .target {
            return ["100%",
                    "75%",
                    "50%",
                    "25%"]
        }

        let maxPoint = model.values.map { ($0.yValue)}.max() ?? 0
        let ratio = getHistorySportRatio()
        let step = ((Int(maxPoint) / 4 / Int(ratio)) + 1) * Int(ratio)
        var textDataSource = [String]()
        for i in 1 ... 4 {
            let yValue = (i * step)

            if i == 4 {
                maxYValueWithScale = yValue
            }
            var yValueStr = yValue.description
            var yValueNew = yValue
//            if yValue > 1000 {
//                yValueNew = yValueNew / 1000
//                yValueStr = yValueNew.description + "K"
//            }

            textDataSource.append(yValueStr)
        }
        textDataSource.reverse()
        return textDataSource
        
    }
    
    private func getHistorySportRatio() ->CGFloat {
        
        let maxPoint = model.values.map { ($0.yValue)}.max() ?? 0
        switch maxPoint {
        case 0 ..< 100:
            return 1
            
        case 100 ..< 1000:
            return 10
            
        case 1000 ..< 10000:
            return 100
            
        case 10000 ..< 100000:
            return 1000
            
        case 100000 ..< 1000000:
            return 10000
            
        default:
            return 100000
        }
    }
    
    private func drawSportPillar(_ color: UIColor) {
        
        pillarItems.removeAll()

        var maxYvalue = CGFloat(maxYValueWithScale)

        if model.type == .target {
            maxYvalue = 100
        }

        //固定没每份的宽度。这里就可以根据x值的index来确定Layer的起始X坐标了
        var count = 12
        switch model.summaryType {
        case .month:
            count = 30
        default:
            break
        }
        
        //要预留底部一根线的间隙
        let pillarTotalHeight = (charsLayer.bounds.maxY - 1)
        let pillarTotalWidth = charsLayer.bounds.maxX - Constant.yValuesWidth
        let scale = (pillarTotalWidth) / CGFloat(count)
        
        let pillarWidth: CGFloat = (pillarTotalWidth) / CGFloat(count * 2)
        
        for i in 0 ..< model.values.count {
            
            let sportValueModel = model.values[i]
            
            let pillarX = (pillarWidth / 2) + (sportValueModel.xValue.toCGFloat()) * scale
            let pillarHeight = ((sportValueModel.yValue) / maxYvalue) * pillarTotalHeight
            let pillarY = pillarTotalHeight - pillarHeight
            
            let pillarPath = UIBezierPath.init(rect: CGRect.init(x: pillarX, y: pillarY, width: pillarWidth, height: pillarHeight))
            let pillarLayer = CAShapeLayer()
            pillarLayer.path = pillarPath.cgPath
            pillarLayer.fillColor = color.cgColor
            
            let pillarItem = PillarItem.init(bezierPath: pillarPath, shapeLayer: pillarLayer)
            pillarItems.append(pillarItem)
            
            charsLayer.addSublayer(pillarLayer)
            
        }
    }
    private func drawSportIndicatorShapeLayer(_ color: UIColor) {
        
        let bezierPath = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: 0.5, height: charsLayer.bounds.height))
        
        indicatorLineLayer.fillColor = UIColor.white.cgColor
        indicatorLineLayer.path = bezierPath.cgPath
        indicatorLineLayer.isHidden = true
        charsLayer.addSublayer(indicatorLineLayer)
    }
    
    private func drawSportIndicatorTextLayer(_ color: UIColor) {
        
        let textFrame = CGRect.init(x: self.centerX - (Constant.indicatorTextLayerWidth / 2), y: indicatorTextLayerY - Constant.indicatorTextLayerHeight, width: Constant.indicatorTextLayerWidth, height: Constant.indicatorTextLayerHeight)
        let textLayer = FDVerticalCenterTextLayer()
        textLayer.isHidden = true
        textLayer.frame = textFrame
        textLayer.position = CGPoint.init(x: textFrame.midX, y: textFrame.midY)
        textLayer.contentsScale = UIScreen.main.scale
        
        textLayer.cornerRadius = 5
        textLayer.masksToBounds = true
        
        let font = UIFont.systemFont(ofSize: 15.auto())
        textLayer.font = CGFont.init(font.fontName as CFString)
        textLayer.fontSize = font.pointSize
        
        //Set string
        let valuesCount = model.values.count
        let sportValueModel = model.values[safe: valuesCount / 2] ?? SportValueModel()
        textLayer.string =  sportValueModel.yValue.description

        textLayer.alignmentMode = kCAAlignmentCenter
        //        textLayer.backgroundColor = color.lighterColor.cgColor
        textLayer.backgroundColor = UIColor.RGB(r: 253, g: 134, b: 8).cgColor
        textLayer.foregroundColor = UIColor.white.cgColor
        indicatorTextLayer = textLayer
        charsLayer.addSublayer(indicatorTextLayer)
        
    }
    
}


/// 柱子的结构体。用来保存柱子的Layer和Path.在触摸事件用要用到
struct PillarItem {
    
    var path = UIBezierPath()
    var layer = CAShapeLayer()
    init(bezierPath: UIBezierPath, shapeLayer: CAShapeLayer) {
        self.path = bezierPath
        self.layer = shapeLayer
    }
}

