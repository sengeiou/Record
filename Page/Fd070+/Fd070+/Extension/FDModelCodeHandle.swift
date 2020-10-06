//
//  FDModelCodeHandle.swift
//  FD070+
//
//  Created by WANG DONG on 2019/3/19.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct FDDecoder {
    
    
    //TODO:转换模型(单个)
    public static func decode<T>(_ type: T.Type, param: [String:Any]) -> T? where T:Decodable{
        guard let jsonData = self.getJsonData(with: param)else{
            return nil
            
        }
        guard let model = try?JSONDecoder().decode(type, from: jsonData)else{
            return nil
            
        }
        return model
        
    }
    //多个
    public static func decode<T>(_type:T.Type, array: [[String:Any]]) -> [T]? where T:Decodable{
        if let data = self.getJsonData(with: array){
            if let models = try?JSONDecoder().decode([T].self, from: data){
                return models
                
            }
            
        }else{
            print("模型转换->转换data失败")
            
        }
        return nil
        
    }
    private static func getJsonData(with param:Any)->Data?{
        if !JSONSerialization.isValidJSONObject(param){
            return nil
            
        }
        guard let data = try?JSONSerialization.data(withJSONObject: param, options: [])else{
            return nil
            
        }
        return data
        
    }
    
}
//模型转字典，或转json字符串
struct FDEncoder {
    
    public static func encoder<T>(toString model:T) ->String? where T:Encodable
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model)else{
            return nil
            
        }
        guard let jsonStr = String(data: data, encoding: .utf8)else{
            return nil
            
        }
        return jsonStr
        
    }
    public static func encoder<T>(toDictionary model:T) ->[String:Any]? where T:Encodable{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model)else{
            return nil
            
        }
        guard let dict = try?JSONSerialization.jsonObject(with: data, options: .mutableLeaves)as? [String:Any]else{
            return nil
            
        }
        return dict
        
    }
    
}
