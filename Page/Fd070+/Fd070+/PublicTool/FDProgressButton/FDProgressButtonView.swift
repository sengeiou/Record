//
//  ProgressButtonView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/6.
//  Copyright © 2019 WANG DONG. All rights reserved.
//
import UIKit

enum ProgressButtonStyle {
    
    case White
    case Black
    case Gray
    case Blue
    case Green
    case Orange
    case Red
}


enum ProgressButtonState {
    case Begin
    case Moving
    case WillCancel
    case DidCancel
    case End
    case Click
}

typealias ActionState = (_ state: ProgressButtonState) -> Void

class FDProgressButtonView: UIView {
    
    /// 计时时长
    var interval: Float = 2.5
    
    /// 按钮样式
    var style: ProgressButtonStyle = .White {
        didSet{
            switch style {
            case .White:
                self.progressButton.backgroundColor =  UIColor.white
                self.progressLayer.strokeColor = UIColor.white.cgColor
                self.ringLayer.fillColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8).cgColor
            case .Black:
                self.progressButton.backgroundColor =  UIColor.black
                self.progressLayer.strokeColor = UIColor.black.cgColor
                self.ringLayer.fillColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8).cgColor
            case .Gray:
                self.progressButton.backgroundColor =  UIColor.gray
                self.progressLayer.strokeColor = UIColor.gray.cgColor
                self.ringLayer.fillColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8).cgColor
            case .Blue:
                self.progressButton.backgroundColor =  UIColor.blue
                self.progressLayer.strokeColor = UIColor.hexColor(0x0089bf).cgColor
                self.ringLayer.fillColor = UIColor.init(red: 0/255.0, green: 79/255.0, blue: 131/255.0, alpha: 0.8).cgColor
            case .Green:
                self.progressButton.backgroundColor =  UIColor.green
                self.progressLayer.strokeColor = UIColor.green.cgColor
                self.ringLayer.fillColor = UIColor.init(red: 0/255.0, green: 249/255.0, blue: 0/255.0, alpha: 0.8).cgColor
            case .Orange:
//                self.progressButton.backgroundColor =  UIColor.orange
                self.progressLayer.strokeColor = UIColor.hexColor(0xf26f2b).cgColor
                self.ringLayer.fillColor = UIColor.init(red: 242/255.0, green: 111/255.0, blue: 43/255.0, alpha: 0.8).cgColor
            case .Red:
                self.progressButton.backgroundColor =  UIColor.red
                self.progressLayer.strokeColor = UIColor.red.cgColor
                self.ringLayer.fillColor = UIColor.init(red: 255/255.0, green: 38/255.0, blue: 0/255.0, alpha: 0.8).cgColor
            }
        }
    }
    
    var progressBtnColor: UIColor! {
        
        didSet {
            self.progressButton.backgroundColor = progressBtnColor
        }
    }
    
    /// 圆环颜色
    var ringColor: UIColor! {
        
        didSet {
            self.ringLayer.fillColor = ringColor.cgColor
        }
    }
    
    /// 进度条颜色
    var progressColor: UIColor! {
        
        didSet {
            self.progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    
    private lazy var centerLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private lazy var ringLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.init(red: 255/255.0, green: 147/255.0, blue: 0/255.0, alpha: 0.8).cgColor
        return layer
    }()
    
    private lazy var progressLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.blue.cgColor
        layer.lineWidth = 10
        layer.lineCap = kCALineCapRound
        return layer
    }()
    
    private lazy var link: CADisplayLink = {
        let link = CADisplayLink.init(target: self, selector: #selector(linkRun))
        link.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        link.isPaused = true
        link.frameInterval = 1
        return link
    }()
    
    var progressButton = UIButton(type: .custom)
    
    private var tempInterval: Float = 0.0
    private var progress: Float = 0.0
    private var isTimeOut: Bool = false
    private var isPressed: Bool = false
    private var isCancel: Bool = false
    private var ringFrame: CGRect = .zero
    
    private var buttonAction: ActionState?
    var progressBtnAction: (() -> ())?

    deinit {
        print("deinit LZPressButton")
        self.link.invalidate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(ringLayer)
        self.layer.addSublayer(centerLayer)
        self.backgroundColor = UIColor.clear
        

        progressButton.setImage(UIImage.init(named: "activity_stop01"), for: .normal)
//        progressButton.backgroundColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        progressButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        progressButton.layer.masksToBounds = true
        progressButton.layer.cornerRadius = self.bounds.width/2
        progressButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        progressButton.isUserInteractionEnabled = false
        progressButton.titleLabel?.adjustsFontSizeToFitWidth = true

        self.addSubview(progressButton)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressGesture))
        self.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func linkRun() {
        
        tempInterval += 1/60.0
        progress = tempInterval/2
        
        if tempInterval >= interval {
            
            self.stop()
            isTimeOut = true
            if self.progressBtnAction != nil{
                self.progressBtnAction!()
            }
            if let closure = self.buttonAction {
                closure(.End)
            }
        }
        
        self.setNeedsDisplay()
    }
    
    func actionWithClosure(_ closure: @escaping ActionState) {
        
        self.buttonAction = closure
    }
    
    @objc private func tapGesture() {
        
        if let closure = self.buttonAction {
            closure(.Click)
        }
    }
    
    @objc private func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            
            self.link.isPaused = false
            self.isPressed = true
            self.layer.addSublayer(self.progressLayer)
            if let closure = self.buttonAction {
                closure(.Begin)
            }
        case .changed:
            let point = gesture.location(in: self)
            if self.ringFrame.contains(point) {
                self.isCancel = false
                if let closure = self.buttonAction {
                    closure(.Moving)
                }
            } else {
                self.isCancel = true
                if let closure = self.buttonAction {
                    closure(.WillCancel)
                }
            }
        case .ended:
            self.stop()
     
            if self.isCancel {
                if let closure = self.buttonAction {
                    closure(.DidCancel)
                }
            } else if self.isTimeOut == false {
                if let closure = self.buttonAction {
                    closure(.End)
                }
            }
            
            self.isTimeOut = false
        default:
            self.stop()
            self.isCancel = true
            if let closure = self.buttonAction {
                closure(.DidCancel)
            }
        }
        
        self.setNeedsDisplay()
    }
    
    func stop() {
        
        isPressed = false
        tempInterval = 0.0
        progress = 0.0
        progressButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.progressLayer.strokeEnd = 0;
        self.progressLayer.removeFromSuperlayer()
        self.link.isPaused = true
        self.setNeedsDisplay()
        
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let width = self.bounds.width
        
        var mainWidth = width
        
        var mainFrame = CGRect(x: 0, y: 0, width: mainWidth, height: mainWidth)
        
        self.progressButton.frame = mainFrame
        progressButton.layer.masksToBounds = true
        progressButton.layer.cornerRadius = mainWidth/2.0
        
        var ringFrame = mainFrame.insetBy(dx: -0.01*mainWidth/2.0, dy: -0.01*mainWidth/2.0);
        self.ringFrame = ringFrame
        
        if self.isPressed {
            ringFrame = mainFrame.insetBy(dx: -0.6*mainWidth/2.0, dy: -0.6*mainWidth/2.0)
        }
        
        let ringPath = UIBezierPath.init(roundedRect: ringFrame, cornerRadius: ringFrame.width/2.0)
        self.ringLayer.path = ringPath.cgPath
        
        if self.isPressed {
            mainWidth *= 0.8
            mainFrame = CGRect.init(x: (width - mainWidth)/2.0, y: (width - mainWidth)/2.0, width: mainWidth, height: mainWidth)
            self.progressButton.frame = mainFrame
            progressButton.layer.masksToBounds = true
            progressButton.layer.cornerRadius = mainWidth/2.0
            self.progressButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        }
        
        let mainPath = UIBezierPath.init(roundedRect: mainFrame, cornerRadius: mainWidth/2.0)
        self.centerLayer.path = mainPath.cgPath
        
        if self.isPressed {
            
            let progressFrame = ringFrame.insetBy(dx: 2.0, dy: 2.0)
            let progressPath = UIBezierPath.init(roundedRect: progressFrame, cornerRadius: progressFrame.width/2.0)
            self.progressLayer.path = progressPath.cgPath
            self.progressLayer.strokeEnd = CGFloat(self.progress)
        }
        
      
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
