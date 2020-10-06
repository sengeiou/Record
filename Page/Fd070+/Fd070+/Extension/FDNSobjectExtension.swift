//
//  FDNSobjectExtension.swift
//  FD070+
//
//  Created by WANG DONG on 2019/3/15.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
extension NSObject {
    /**
     获取对象对于的属性值，无对于的属性则返回NIL
     - parameter property: 要获取值的属性
     - returns: 属性的值
     */
    func getValueOfProperty(property:String)->AnyObject?{
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)){
            return self.value(forKey: property) as AnyObject
        }else{
            return nil
        }
    }
    
    /**
     设置对象属性的值
     - parameter property: 属性
     - parameter value:    值
     - returns: 是否设置成功
     */
    func setValueOfProperty(property:String,value:AnyObject)->Bool{
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)){
            self.setValue(value, forKey: property)
            return true
            
        }else{
            return false
        }
    }
    
    ///  获取对象的所有属性名称 注意:必须在获取类的class前添加 (@objcMembers)不然获取为空数组 例:@objcMembersclass Person: NSObject
    func getAllPropertys()->[String]{
        // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        var count: UInt32 = 0
        let properties = class_copyPropertyList(Person.self, &count)
        var propertyNames: [String] = []
        // Swift中类型是严格检查的，必须转换成同一类型
        for i in 0..<Int(count) {
            // UnsafeMutablePointer<objc_property_t>是
            // 可变指针，因此properties就是类似数组一样，可以
            // 通过下标获取
            let property = properties![i]
            let name = property_getName(property)
            // 这里还得转换成字符串
            let strName =  String(cString: name) //String.fromCString(name);
            propertyNames.append(strName);
        }
        // 不要忘记释放内存，否则C语言的指针很容易成野指针的
        free(properties)
        return propertyNames;
    }
    
    
    
    public func describLog(project:NSObject)  {
        for name in project.getAllPropertys() {
            print("\(name) : \(project.getValueOfProperty(property: name) ?? "" as AnyObject)")
        }
    }
}
@objcMembers class Person: NSObject {
    
}
