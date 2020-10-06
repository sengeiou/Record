//
//  WaveLayer.swift
//  liquid-swipe
//
//  Created by Anton Skopin on 04/01/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

internal class FDWaveLayer: CAShapeLayer {

    var waveARCHeight: CGFloat //弧形的高度
    var waveARCWidth: CGFloat //弧形的宽度
    var sideHeight: CGFloat //距离下面层偏移的距离
    init(waveARCHeight: CGFloat, waveARCWidth: CGFloat, sideHeight: CGFloat) {
        self.waveARCHeight = waveARCHeight  //圆弧中心点的X坐标
        self.waveARCWidth = waveARCWidth //圆弧的半径
        self.sideHeight = sideHeight
        super.init()
    }
    
    func updatePath() {
        let rect = bounds
        let path = CGMutablePath()
        let maskWidth = rect.width
        let maskHeight = rect.height - self.sideHeight
        
        path.move(to: CGPoint(x: maskWidth, y: maskHeight))
        path.addLine(to: CGPoint(x: maskWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: maskHeight))

        
        path.addLine(to: CGPoint(x: (maskWidth - waveARCWidth)/2, y: maskHeight))
        
        let allPointsArray = [CGPoint(x: (maskWidth - waveARCWidth)/2, y: maskHeight),CGPoint(x: maskWidth/2, y: maskHeight - waveARCHeight),CGPoint(x: (maskWidth - waveARCWidth)/2 + waveARCWidth, y: maskHeight)]
        var PrePonit = CGPoint()
        
        for i in 0..<allPointsArray.count {
            if i == 0 {
                PrePonit = allPointsArray[0]
            }else {
                let newPoint = allPointsArray[i]
                path.addCurve(to: newPoint, control1: CGPoint(x: (PrePonit.x+newPoint.x)/2, y: PrePonit.y), control2: CGPoint(x: (PrePonit.x+newPoint.x)/2, y: newPoint.y))
                PrePonit = newPoint
            }
        }
        path.addLine(to: CGPoint(x: maskWidth, y: maskHeight))
        path.closeSubpath()
        self.path = path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
