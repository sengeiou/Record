//
//  HistoryBloodSugarChartsView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

class HistoryBloodSugarChartsView: UIView {

    private struct Constant {

        static let chartDescriptionViewHeigth: CGFloat = 50.auto()
        static let margin:CGFloat = 30
        static let bottomBGLayerHeight: CGFloat = 15.auto()
        static let charsLayerYValueWidth: CGFloat = 30.auto()
        static let xValuesLayerHeight: CGFloat = 50.auto()

        static let textHeight: CGFloat = 15.auto()

        static let bloodSugarFillColor = UIColor.RGB(r: 250, g: 0, b: 80)
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


    let charsLayer = CALayer()
    let xValuesLayer = CALayer()

    let indicatorLineLayer = CAShapeLayer()

    var pillarItems = [ChunkItem]()
    var curveItems = [CGPoint]()
    var curveWidth: CGFloat = 10

    var xValueTextLayers = [CATextLayer]()

    let waveMaskBGLayer = CALayer.init()
    var sliderLayer = CALayer() //滑块Layer
    private var heightUnite:CGFloat = 0 //移动时的高度单位
    private var centerXWidth:CGFloat = 0 //中心点之间的距离

    var model: HistoryBloodSugarChartsModel = HistoryBloodSugarChartsModel() {

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

        dateLabel.text = model.date
        valueLabel.text = HistoryBloodSugarChartsManager.getBloodSugarString(model.value.toCGFloat())
        unitLabel.text = model.unit

        prepareDrawCharts()

    }
    private func configUI() {

        //放置图表信息控件的View
        let chartDescriptionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: Constant.chartDescriptionViewHeigth))
        chartDescriptionView.backgroundColor = Constant.mainBGColor
        addSubview(chartDescriptionView)

        chartDescriptionView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
        }

        chartDescriptionView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        chartDescriptionView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(valueLabel.snp.right)
            make.bottom.equalTo(valueLabel)
        }

    }

    /// 设置一些图层。再画图
    private func prepareDrawCharts() {
        layoutSubviews()

        addContentViewCharts()

        drawBloodSugarCharts(Constant.bloodSugarFillColor)

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
extension HistoryBloodSugarChartsView {

    private func addWaveLayer() {

        //放置滑块的Layer
        sliderLayer.frame = CGRect(x: 0, y: xValuesLayer.height - Constant.sliderViewHeight, width:CGFloat(Int(Constant.sliderViewWidth)), height: Constant.sliderViewHeight)
        sliderLayer.backgroundColor = UIColor.white.cgColor

        //sliderLayer抗锯齿
        sliderLayer.borderWidth = 3
        sliderLayer.borderColor =  UIColor.clear.cgColor
        sliderLayer.shouldRasterize = true
        sliderLayer.rasterizationScale = UIScreen.main.scale

        xValuesLayer.addSublayer(sliderLayer)

        //滑块的遮罩的Layer
        waveMaskBGLayer.frame = CGRect(x: 0, y: 0, width: Constant.sliderViewWidth, height: Constant.sliderViewHeight)
        waveMaskBGLayer.backgroundColor = Constant.mainBGColor.cgColor
        sliderLayer.addSublayer(waveMaskBGLayer)

        let waveMask = FDWaveLayer(waveARCHeight: Constant.sliderViewHeight/2, waveARCWidth: Constant.sliderViewWidth, sideHeight: Constant.sliderOffsetHeight)
        waveMask.frame = waveMaskBGLayer.bounds

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
                (self.sliderLayer.frame.maxX <= label.frame.maxX &&  self.sliderLayer.frame.maxX >= label.frame.minX) ||                  //判断右边进入的label
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
extension HistoryBloodSugarChartsView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setSuperviewScrollEnabled(false)
        indicatorLineLayer.isHidden = false
        handleTouchEvents(touches, event: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setSuperviewScrollEnabled(false)
        indicatorLineLayer.isHidden = false
        handleTouchEvents(touches, event: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            self.indicatorLineLayer.isHidden = true
        }
        handleTouchEvents(touches, event: event)
        setSuperviewScrollEnabled(true)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            self.indicatorLineLayer.isHidden = true
        }
        handleTouchEvents(touches, event: event)
        setSuperviewScrollEnabled(true)
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

        indicatorLineLayer.frame.origin.x = charsLayerPoint.x

        handleSliderPointView(charsLayerPoint)
        handleHeartRateTouchEvents(charsLayerPoint)

    }

    /// 设置父视图Scroller是否可以滚动
    ///
    /// - Parameter enabled: 是否可以滚动
    fileprivate func setSuperviewScrollEnabled(_ enabled: Bool ) {


        if let superView = self.superview as? UIScrollView {
            superView.isScrollEnabled = enabled
            superView.isUserInteractionEnabled = enabled
        }
    }

}

// MARK: - Public
extension HistoryBloodSugarChartsView {

    func drawXValues() {

        xValueTextLayers.removeAll()

        var textLayerStrArr = ["00:00", "06:00", "12:00", "18:00", "00:00"]

        let textTotalWidth = charsLayer.bounds.maxX - 20 - (Constant.margin / 2)
        let textScale = (textTotalWidth) /  CGFloat(textLayerStrArr.count)

        //设置textLayer的升级高度
        self.centerXWidth = (textScale + Constant.sliderViewWidth/2)
        self.heightUnite = CGFloat(Constant.sliderViewHeight - Constant.sliderOffsetHeight)/self.centerXWidth

        let textWidth: CGFloat = (textTotalWidth) / CGFloat(textLayerStrArr.count * 2)

        for i in 0 ..< textLayerStrArr.count {


            let textX = (Constant.margin / 4) + textWidth + CGFloat(i) * textScale
            let textRect = CGRect.init(x: textX, y: xValuesLayer.height - Constant.textHeight, width: textWidth + 8, height: Constant.textHeight)

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
        layer.addSublayer(charsLayer)
        
        //最底部哪个一条条的白色背景的Layer
        let bottomBGLayer = CALayer()
        bottomBGLayer.backgroundColor = UIColor.white.cgColor
        bottomBGLayer.frame = CGRect.init(x: 0, y: self.height - Constant.bottomBGLayerHeight, width: self.width, height: Constant.bottomBGLayerHeight)
        layer.addSublayer(bottomBGLayer)


        //放X轴数据的Layer(包括滑动动画的Layer)
        xValuesLayer.frame = CGRect.init(x: 0, y: charsLayer.bottom, width: self.width, height: Constant.xValuesLayerHeight)
        xValuesLayer.backgroundColor = Constant.mainBGColor.cgColor
        layer.addSublayer(xValuesLayer)

        //滑动底部哪个长方体的背景Layer
        let sliderBGLayer = CALayer()
        sliderBGLayer.backgroundColor = UIColor.white.cgColor
        sliderBGLayer.frame = CGRect.init(x: 0, y: Constant.xValuesLayerHeight - Constant.bottomBGLayerHeight, width: self.width, height: Constant.bottomBGLayerHeight)
        xValuesLayer.addSublayer(sliderBGLayer)


    }
}

// MARK: - Factory func
extension HistoryBloodSugarChartsView {

    func getBaseAnimation(_ keyPath: String) -> CABasicAnimation {

        let baseAnimation = CABasicAnimation(keyPath: keyPath)
        baseAnimation.duration = 1
        baseAnimation.fromValue = 0
        baseAnimation.toValue = 1
        baseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return baseAnimation
    }

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

        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.white.cgColor

        return textLayer
    }

    func addLayerAnimationOpacity() -> CABasicAnimation {

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.toValue = 0.3
        animation.duration = 0.25
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation

    }


}
extension HistoryBloodSugarChartsView {

    func drawBloodSugarCharts(_ color: UIColor) {

        drawBloodSugarAbscissaAndYLabels()
        drawBloodSugarChunk(color)
        drawBloodSugarIndicator(color)

    }

    func drawBloodSugarAbscissaAndYLabels () {

        //画Y坐标的横向
        //要预留底部那根线的间隙
        let bottomY = charsLayer.height - 1
        let YAxissScale = (bottomY ) / 6

        for i in 0 ... 6 {

            let originY = bottomY - YAxissScale * CGFloat(i)
            var originX: CGFloat = 0
            var lineSize = CGSize.init(width: charsLayer.width, height: 0.5)
            if i != 0 || i != 6 {
                originX = Constant.charsLayerYValueWidth
                lineSize.width -= Constant.charsLayerYValueWidth
            }
            let origin:CGPoint = CGPoint.init(x: originX , y: originY)
            let rect = CGRect.init(origin: origin, size: lineSize)

            let lineLayer = CALayer()
            lineLayer.frame = rect
            lineLayer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.8)
            charsLayer.addSublayer(lineLayer)


        }

        //画Y坐标的血糖高低指示背景Layer
        let colors = [UIColor.blue, UIColor.green, UIColor.red]
        let strings = ["MydayVC_bloodSugarValue_low".localiz(),
                       "MydayVC_bloodSugarValue_normal".localiz(),
                       "MydayVC_bloodSugarValue_high".localiz()]

        for i in 0 ... 2 {

            let textWidth: CGFloat = Constant.charsLayerYValueWidth
            let height = YAxissScale * 2

            let y = bottomY - height * CGFloat(i + 1)

            let textBGLayer = CALayer()
            textBGLayer.frame = CGRect.init(x: 0, y: y, width: textWidth, height: height)
            textBGLayer.backgroundColor = colors[i].cgColor.copy(alpha: 0.5)
            charsLayer.addSublayer(textBGLayer)

            let textLayerFrame = CGRect.init(x: 0, y: (textBGLayer.height - textWidth ) / 2, width: textWidth, height: textWidth)
            let textLayerString = strings[i]
            let textLayerSize: CGFloat = 7.auto()
            let textLayer = getTextLayer(frame: textLayerFrame, string: textLayerString, size: textLayerSize)
            textBGLayer.addSublayer(textLayer)

        }
    }

    private func drawBloodSugarChunk(_ color: UIColor) {

        pillarItems.removeAll()

        let count =  model.values.count
        let chunkWidth: CGFloat = 10
        
        let scaleX = (charsLayer.width - Constant.charsLayerYValueWidth) / CGFloat( count)
        let scaleY = charsLayer.height / 6

        var positionY = [CGFloat]()
        for i in 0 ... 2 {
            let y = scaleY * CGFloat((i * 2) + 1)
            positionY.append(y)

        }
        positionY.reverse()

        for i in 0 ..< count {

            let yValue = model.values[i].yValue

            if yValue == 0 {
                continue
            }

            var pointY:CGFloat = positionY[2]
            if yValue == 1 {
                pointY = positionY[0]
            }else if yValue == 2 {
                pointY = positionY[1]
            }

            let pointX = MydayConstant.chartViewYValueWidth + (CGFloat(i) * scaleX)
            let rect = CGRect.init(x: pointX , y: pointY - (chunkWidth / 2), width: chunkWidth + (chunkWidth / 2) , height: chunkWidth)
//            let path = UIBezierPath.init(roundedRect: rect,s cornerRadius: chunkWidth / 2)
             let path = UIBezierPath.init(ovalIn: rect)


            let chunkLayer = CAShapeLayer()
            chunkLayer.path = path.cgPath
            //最后一个
            if i == count - 1 {
                chunkLayer.fillColor = UIColor.RGB(r: 252, g: 175, b: 203).cgColor
                chunkLayer.strokeColor = color.cgColor
            }else {
                //一般的
                chunkLayer.fillColor = color.cgColor
            }

            let chunkAnimation = getBaseAnimation("opacity")
            chunkLayer.add(chunkAnimation, forKey: "chunkLayer.CABasicAnimation")
            charsLayer.addSublayer(chunkLayer)

            let pillarItem = ChunkItem.init(bezierPath: path, shapeLayer: chunkLayer)
            pillarItems.append(pillarItem)

        }

    }
    private func drawBloodSugarIndicator(_ color: UIColor) {

        let bezierPath = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: 0.5, height: charsLayer.height))
        indicatorLineLayer.fillColor = color.cgColor
        indicatorLineLayer.path = bezierPath.cgPath
        indicatorLineLayer.isHidden = true
        charsLayer.addSublayer(indicatorLineLayer)
    }
}

//Handle
extension HistoryBloodSugarChartsView {

    func handleHeartRateTouchEvents(_ point: CGPoint) {

        for (index, item) in pillarItems.enumerated() {

            let rect = charsLayer.convert(item.path.bounds, from: item.layer)

            if point.x > rect.minX && point.x < rect.maxX {
                valueLabel.text = HistoryBloodSugarChartsManager.getBloodSugarString(model.values[index].yValue)
                item.layer.fillColor = Constant.bloodSugarFillColor.lighterColor.cgColor
                indicatorLineLayer.frame.origin.x = charsLayer.convert(item.path.bounds, to: charsLayer).midX

            }else {
                item.layer.fillColor = Constant.bloodSugarFillColor.cgColor
            }
        }

    }
}

struct ChunkItem {

    var path = UIBezierPath()
    var layer = CAShapeLayer()
    init(bezierPath: UIBezierPath, shapeLayer: CAShapeLayer) {
        self.path = bezierPath
        self.layer = shapeLayer
    }
}
