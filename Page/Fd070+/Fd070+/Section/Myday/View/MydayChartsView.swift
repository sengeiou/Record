//
//  MydayChartsView.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/13.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

class MydayChartsView: UIView {
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: 30.auto())
        valueLabel.textColor = .white
        return valueLabel
    }()
    
    lazy var unitLabel: UILabel = {
        let unitLabel = UILabel()
        unitLabel.textColor = .white
        return unitLabel
    }()
    
    var maxXModel = PointModel()
    var maxYModel = PointModel()
    var minYModel = PointModel()
    
    var bloodSugarScale: CGFloat = 0
    
    let kMargin:CGFloat = 30.auto()
    let XValueLayerHeight: CGFloat = 40.auto()
    
    var columnWidth:CGFloat = 0
    var chunkWidth: CGFloat = 0
    
    var chartH:CGFloat = 0
    var chartW:CGFloat = 0
    
    var contentView: UIView!
    
    var chartsFillColor = UIColor.clear
    
    var mydaySportPillarItems = [MydayPillarItem]()
    var mydayHeatRateDotItems = [MydayPillarItem]()
    var mydayBoodSugarChunkItems = [MydayPillarItem]()
    
    var indicatorLayer = CALayer()
    
    fileprivate var chartMinX: CGFloat = 0
    fileprivate var chartMaxX: CGFloat = 0
    
    var bloodSugarTestClosure: (() ->())?
    
    var model: ChartModel = ChartModel() {
        didSet {
            self.draw()
        }
    }
    
    private func configUI() {
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(3.auto())
        }
        
        contentView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(valueLabel.snp.bottom)
            make.left.equalTo(valueLabel.snp.right)
        }
        
    }
    
    func draw(){
        
        setData()
        setupContentView()
        configUI()
        caculateData()
        
        
        switch model.type {
        case .walk:
            chartsFillColor = MydayConstant.walkChartFillColor
            drawPillarCharts(chartsFillColor)
        case .goal:
            chartsFillColor = MydayConstant.percentFillColor
            drawPillarCharts(chartsFillColor)
        case .sportTime:
            chartsFillColor = MydayConstant.sportTimeChartFillColor
            drawPillarCharts(chartsFillColor)
        case .calorie:
            chartsFillColor = MydayConstant.calorieChartFillColor
            drawPillarCharts(chartsFillColor)
        case .distance:
            chartsFillColor = MydayConstant.distanceChartFillColor
            drawPillarCharts(chartsFillColor)
        case .sleepTime:
            chartsFillColor = MydayConstant.sleepTimeFillColor
            drawPillarCharts(chartsFillColor)
        case .bloodSugar:
            chartsFillColor = MydayConstant.bloodSugarFillColor
            drawChunkCharts(chartsFillColor)
        case .heartRate:
            chartsFillColor = MydayConstant.heartRateFillColor
            drawCurveCharts(chartsFillColor)
        default:
            break
        }
        
        setupIndicatorLayer()
        
    }
    
}
// MARK: - Setup contenView
extension MydayChartsView {
    
    fileprivate func setupContentView() {
        
        //三角形的高
        let triangleWidth: CGFloat = MydayConstant.chartViewTriangleWidth
        
        //默认箭头在左边显示
        //高度设置2倍。看着更精瘦些
        var topPoint = CGPoint.init(x: SCREEN_WIDTH / 4, y: 0)
        var leftBottomPoint = CGPoint.init(x: SCREEN_WIDTH / 4 - triangleWidth, y: triangleWidth * 2)
        var rightBottomPoint = CGPoint.init(x: SCREEN_WIDTH / 4 + triangleWidth, y: triangleWidth * 2)
        
        switch model.type {
        //箭头在右边显示
        case .goal, .calorie, .sleepTime, .heartRate:
            let triangleX = (SCREEN_WIDTH / 4) * 3
            topPoint = CGPoint.init(x: triangleX, y: 0)
            leftBottomPoint = CGPoint.init(x: triangleX - triangleWidth, y: triangleWidth * 2)
            rightBottomPoint = CGPoint.init(x: triangleX + triangleWidth, y: triangleWidth * 2)
            
        default:
            break
        }
        
        
        let markPath = UIBezierPath.init()
        markPath.lineWidth = 1
        markPath.move(to: topPoint)
        markPath.addLine(to: leftBottomPoint)
        markPath.addLine(to: rightBottomPoint)
        markPath.close()
        layer.addSublayer(getMarkShape(markPath))
        
        contentView = UIView.init()
        contentView.backgroundColor = MydayConstant.chartBackgroundColor
        //                contentView.backgroundColor = UIColor.randomColor
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(triangleWidth)
        }
    }
    
    /// 设置指示器的Layer
    fileprivate func setupIndicatorLayer() {
        
        if model.descModel.count == 1, maxXModel.yValue == 0 {
            return
        }
        
        
        indicatorLayer = CALayer()
        //顶部设置的空余高度
        let topRestHeight = MydayConstant.chartViewTriangleWidth + MydayConstant.chartViewValueLabelHeight + (kMargin / 4)
        let point = CGPoint.init(x: SCREEN_WIDTH / 2, y: topRestHeight)
        let size = CGSize.init(width: 0.5, height: self.height - topRestHeight - XValueLayerHeight)
        indicatorLayer.frame = CGRect.init(origin: point, size: size)
        indicatorLayer.backgroundColor = UIColor.white.cgColor
        indicatorLayer.isHidden = true
        //血糖不显示显示滑动指示器
        if model.type == .bloodSugar {
            indicatorLayer.height = 0
        }
        contentView.layer.addSublayer(indicatorLayer)
    }
    fileprivate func getMarkShape(_ path: UIBezierPath) -> CAShapeLayer {
        
        let markShapeLayer = CAShapeLayer()
        markShapeLayer.strokeColor = MydayConstant.chartBackgroundColor.cgColor
        markShapeLayer.path = path.cgPath
        markShapeLayer.fillColor = MydayConstant.chartBackgroundColor.cgColor
        
        return markShapeLayer
    }
    
}
// MARK: - Handle data
extension MydayChartsView {
    
    fileprivate func setData() {
        
        let newestValue = model.value
        //如果没有值就不显示0值和单位值。 3.13
        //        if newestValue == "0" || newestValue == "0.00" || newestValue == "0H:0M" {
        //            valueLabel.isHidden = true
        //            valueLabel.isHidden = true
        //            return
        //        }
        
        //后面加个空格。防止斜体字体被切割
        valueLabel.text = newestValue + " "
        unitLabel.text = model.unit
        
        switch model.type {
        //步数不应有小数点
        case .walk:
            if newestValue.contains(".") {
                valueLabel.text = String(newestValue.dropLast().dropLast()) + " "
            }
        //时间要复文本显示
        case .sportTime, .sleepTime:
            valueLabel.attributedText = MydayManager.highlightDurationUnitWords(model.value)
            
        default:
            break
        }
    }
    
    /// 计算数据，以便画图表的时候可以用
    fileprivate  func caculateData() {
        
        var points = [PointModel]()
        for point in model.descModel {
            points.append(point.points.first!)
        }
        
        maxXModel = points.max(by: { (model0, model1) -> Bool in
            return model0.yValue < model1.yValue
        }) ?? PointModel()
        
        maxYModel = points.max(by: { (model0, model1) -> Bool in
            return model0.yValue < model1.yValue
        }) ?? PointModel()
        
        minYModel = points.max(by: { (model0, model1) -> Bool in
            return model0.yValue > model1.yValue
        }) ?? PointModel()
        
        
        bloodSugarScale = (maxYModel.yValue - minYModel.yValue) / 3
        
        chartH = self.height - (kMargin/4) - MydayConstant.chartViewValueLabelHeight - MydayConstant.chartViewTriangleWidth - XValueLayerHeight
        chartW = self.width - (kMargin/2)
        
        chartMinX = MydayConstant.chartViewYValueWidth + (kMargin / 4)
        chartMaxX = self.width - (kMargin / 4)
        
        columnWidth = 15.auto()
        if model.descModel.count > 5 {
            columnWidth = (chartW - MydayConstant.chartViewYValueWidth) / CGFloat(model.descModel.count * 2)
        }
        
    }
    
    func filterEmptyValue(_ originalValue: String) ->String {
        if originalValue == "0", model.descModel.count == 1 {
            return ""
        }
        return originalValue
    }
    
}
// MARK: - Draw public func
extension MydayChartsView {
    
    
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
        //                textLayer.backgroundColor = UIColor.randomColor.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.preferredFrameSize()
        textLayer.foregroundColor = UIColor.white.cgColor
        
        return textLayer
    }
    
    func getBaseAnimation(_ keyPath: String) -> CABasicAnimation {
        
        let baseAnimation = CABasicAnimation(keyPath: keyPath)
        baseAnimation.duration = 1
        baseAnimation.fromValue = 0
        baseAnimation.toValue = 1
        baseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return baseAnimation
    }
    
    
    func drawDashLine(shapeLayer : CAShapeLayer,lineLength : Int ,lineSpacing : Int,lineColor : UIColor){
        
        shapeLayer.strokeColor = lineColor.cgColor.copy(alpha: 0.5)
        
        shapeLayer.lineWidth = shapeLayer.frame.size.height
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: shapeLayer.frame.size.width, y: 0))
        
        shapeLayer.path = path
        contentView.layer.addSublayer(shapeLayer)
    }
    
    func getBloodSugarHRXValues() -> [String] {
        
        let startInterval = Double(model.descModel.first?.xValue ?? "0") ?? 0
        //没有开始时间
        if startInterval == 0 {
            return ["00:00",
                    "6:00",
                    "12:00",
                    "18:00",
                    "00:00"]
        }
        let endInterval = Date.init(timeIntervalSince1970: startInterval).endOfDay.timeIntervalSince1970 + 1
        let step = (endInterval - startInterval) / 4
        
        var dataSource = [String]()
        for i in 0 ..< 5 {
            let interval = startInterval + (step * Double(i))
            let date = Date.init(timeIntervalSince1970: interval)
            
            let hour = date.hour.description
            var minute = date.minute.description
            if minute.count < 2 {
                minute.insert("0", at: minute.startIndex)
            }
            
            dataSource.append("\(hour):\(minute)")
            
        }
        return dataSource
    }
    
    func getBloodSugarHRXScale(_ descModel: DescModel)-> CGFloat {
        
        let startInterval = Double(model.descModel.first?.xValue ?? "0") ?? 0
        let endInterval  = Date.init(timeIntervalSince1970: startInterval).endOfDay.timeIntervalSince1970 + 1
        
        
        let scaleX = (chartW - MydayConstant.chartViewYValueWidth)  / CGFloat(endInterval - startInterval)
        let current = Double(descModel.xValue) ?? 0
        let interval = current - startInterval
        return CGFloat(interval) * scaleX
    }
}

// MARK: - Touch events
extension MydayChartsView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setSuperviewScrollEnabled(false)
        indicatorLayer.isHidden = false
        handleTouchEvents(touches, event: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches, event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setSuperviewScrollEnabled(true)
        handleTouchEvents(touches, event: event)
        indicatorLayer.isHidden = true
    }
    
    fileprivate func handleTouchEvents(_ touches: Set<UITouch>, event: UIEvent?) {
        
        if (self.model.descModel.isEmpty) {
            return
        }
        
        guard  let _ = event else {
            return
        }
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in:self)
        
        if point.x < chartMinX || point.x > chartMaxX {
            return
        }
        
        indicatorLayer.x = point.x
        switch model.type {
        case .heartRate:
            handleCurveEvent(point)
        case .bloodSugar:
            //血糖数值暂不处理显示
            //            handleChunkEvent(point)
            break
        default:
            handlePillerEvent(point)
        }
        
    }
    private func setSuperviewScrollEnabled(_ enabled: Bool ) {
        
        if let superView = self.superview as? UICollectionView {
            superView.isScrollEnabled = enabled
            
        }
    }
}

