//
//  UIImageExtension.swift
//  Orangetheory
//
//  Created by Payne on 2018/6/12.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    //把Color转成image
    class func getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
// 扩展 UIImage 的 init 方法，获得渐变效果
extension UIImage {

    convenience init?(gradientXColors:[UIColor])
    {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 10, height: 10), true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientXColors.map {(color: UIColor) -> AnyObject? in return color.cgColor as AnyObject? } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        // 第二个参数是起始位置，第三个参数是终止位置
        context!.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0), options: CGGradientDrawingOptions(rawValue: 0))
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        UIGraphicsEndImageContext()
    }
    
    convenience init?(gradientYColors:[UIColor])
    {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 10, height: 10), true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientYColors.map {(color: UIColor) -> AnyObject? in return color.cgColor as AnyObject? } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        // 第二个参数是起始位置，第三个参数是终止位置
        context!.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 10), options: CGGradientDrawingOptions(rawValue: 0))
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        UIGraphicsEndImageContext()
    }
}


