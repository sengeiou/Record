//
//  ExtUITapGestureRecognizer.swift
//  costpang
//
//  Created by FENGBOLAI on 13/8/9.
//  Copyright (c) 2013年 FENGBOLAI. All rights reserved.
//

import Foundation
import UIKit

// 扩展触摸，传递参数

private var PERSON_ID_NUMBER_PROPERTY:AnyObject? 

// UITapGestureRecognizer
extension UITapGestureRecognizer {
    /*
    var data: AnyObject {
        get{
            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
            if result == nil {
                return "" as AnyObject
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
 */
    var dataStr: String? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dataInt: Int? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var data: NSDictionary? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    weak var dataUIView: UIView? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? UIView{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dataMutableArray: NSMutableArray? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSMutableArray{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

// UILongPressGestureRecognizer
extension UILongPressGestureRecognizer {
    
    /*
    var data: AnyObject {
        get{
            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
            if result == nil {
                return "" as AnyObject
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    */
    
    var dataStr: String? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dataInt: Int? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var data: NSDictionary? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

//// UIAlertView
//extension UIAlertView {
//    /*
//    var data: AnyObject {
//        get{
//            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
//            if result == nil {
//                return "" as AnyObject
//            }
//            return result!
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//     */
//    var dataStr: String? {
//        get{
//            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
//                return result
//            }
//            else {
//                return nil
//            }
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//    var dataInt: Int? {
//        get{
//            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
//                return result
//            }
//            else {
//                return nil
//            }
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//    var data: NSDictionary? {
//        get{
//            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
//                return result
//            }
//            else {
//                return nil
//            }
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//}

// UIButton
extension UIButton {
    /*
    var data: AnyObject {
        get{
            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
            if result == nil {
                return "" as AnyObject
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
 */
    var dataStr: String? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dataInt: Int? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var data: NSDictionary? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func addAnimation(_ durationTime: Double) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.isRemovedOnCompletion = true
        
        let animationZoomOut = CABasicAnimation(keyPath: "transform.scale")
        animationZoomOut.fromValue = 0
        animationZoomOut.toValue = 1.2
        animationZoomOut.duration = 3/4 * durationTime
        
        let animationZoomIn = CABasicAnimation(keyPath: "transform.scale")
        animationZoomIn.fromValue = 1.2
        animationZoomIn.toValue = 1.0
        animationZoomIn.beginTime = 3/4 * durationTime
        animationZoomIn.duration = 1/4 * durationTime
        
        groupAnimation.animations = [animationZoomOut, animationZoomIn]
        self.layer.add(groupAnimation, forKey: "addAnimation")
    }
}

// UIPanGestureRecognizer
extension UIPanGestureRecognizer{
    /*
    var data: AnyObject {
        get{
            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
            if result == nil {
                return "" as AnyObject
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
 */
    var dataStr: String? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dataInt: Int? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var data: NSDictionary? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

//// UIActionSheet
//extension UIActionSheet{
//    /*
//    var data: AnyObject {
//        get{
//            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
//            if result == nil {
//                return "" as AnyObject
//            }
//            return result!
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
// */
//    var dataStr: String? {
//        get{
//            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
//                return result
//            }
//            else {
//                return nil
//            }
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//    var dataInt: Int? {
//        get{
//            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
//                return result
//            }
//            else {
//                return nil
//            }
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//    var data: NSDictionary? {
//        get{
//            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
//                return result
//            }
//            else {
//                return nil
//            }
//        }
//        set{
//            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//}


// UIImageView
extension UIImageView{
    /*
    var data: AnyObject {
        get{
            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
            if result == nil {
                return "" as AnyObject
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
 */
    var dataStr: String? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dataInt: Int? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var data: NSDictionary? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// UILabel
extension UILabel{
    /*
    var data: AnyObject {
        get{
            let result: AnyObject? = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as AnyObject?
            if result == nil {
                return "" as AnyObject
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
 */
    var dataStr: String? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? String{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dataInt: Int? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? Int{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var data: NSDictionary? {
        get{
            if let result = objc_getAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY) as? NSDictionary{
                return result
            }
            else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &PERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    func resizeImage() -> UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width / CGFloat(2)), topCapHeight: Int(self.size.height / CGFloat(2)))
    }
}

extension UIColor {
    convenience init(netHex:Int, alpha: CGFloat) {
        let red = (netHex >> 16) & 0xff
        let redf = CGFloat(red) / 255.0
        let green = (netHex >> 8) & 0xff
        let greenf = CGFloat(green) / 255.0
        let blue = netHex & 0xff
        let bluef = CGFloat(blue) / 255.0
        self.init(red: redf, green: greenf, blue: bluef, alpha: alpha)
    }
}


extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
}

extension String{
    //分割字符
    func split(_ s : String)->[String]{
        return self.components(separatedBy: s)
    }
    
    func ped_encodeURI() -> String {
        return PercentEncoding.EncodeURI.evaluate(string: self)
    }
    func ped_encodeURIComponent() -> String {
        return PercentEncoding.EncodeURIComponent.evaluate(string: self)
    }
    func ped_decodeURI() -> String {
        return PercentEncoding.DecodeURI.evaluate(string: self)
    }
    func ped_decodeURIComponent() -> String {
        return PercentEncoding.DecodeURIComponent.evaluate(string: self)
    }
}

extension Data {
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}

