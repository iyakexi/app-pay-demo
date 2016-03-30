//
//  JSON.swift
//  AppPayDemo
//
//  Created by Leon King on 1/29/16.
//  Copyright © 2016 QinYejun. All rights reserved.
//

import Foundation

enum JSON {
    case JSONDictionary([String : JSON])
    case JSONArray([JSON])
    case JSONString(String)
    case JSONNumber(NSNumber)
    case JSONBool(Bool)
    case JSONNull
    
    subscript(key:String) -> JSON? {
        switch self {
        case .JSONDictionary(let value) :
            return value[key]
        default:
            return nil
        }
    }
    
    subscript(index:Int) -> JSON? {
        switch self {
        case .JSONArray(let value):
            return value[index]
        default:
            return nil
        }
    }
    
    var dictionary : [String:JSON]? {
        switch self {
        case .JSONDictionary(let value):
            return value
        default:
            return nil
        }
    }
    
    var array : [JSON]? {
        switch self {
        case .JSONArray(let value):
            return value
        default:
            return nil
        }
    }
    
    var string : String? {
        get {
            switch self {
            case .JSONString(let value):
                return value
            default:
                return nil
            }
        }
    }
    
    var number : NSNumber? {
        get {
            switch self {
            case .JSONNumber(let value):
                return value
            default:
                return nil
            }
        }
    }
    
    var integer: Int? {
        get {
            switch self {
            case .JSONNumber(let value):
                return value.integerValue
            case .JSONString(let value):
                let value = value as NSString
                return value.integerValue
            default:
                return nil
            }
        }
    }
    
    var double: Double? {
        get {
            switch self {
            case .JSONNumber(let value):
                return value.doubleValue
            case .JSONString(let value):
                let value = value as NSString
                return value.doubleValue
            default:
                return nil
            }
        }
    }
    
    
    var bool : Bool? {
        get{
            switch self {
            case .JSONBool(let value):
                return value
            case .JSONNumber(let value):
                return value.boolValue
            case .JSONString(let value):
                let value = value as NSString
                return value.boolValue
            default:
                return nil
            }
        }
    }
    
    static func fromString(str:String) -> JSON? {
        if let jsonData = str.dataUsingEncoding(NSUTF8StringEncoding) {
            return JSON.fromData(jsonData)
        }
        return nil
    }
    
    static func fromData(jsonData:NSData) -> JSON? {
        if let parsed: AnyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0)){
            return JSON.fromObject(parsed)
        }
        return nil
    }
    
    static func fromObject(object:AnyObject) -> JSON? {
        //println(object.dynamicType)
        //println(object)
        switch object {
        case _ as NSNull:
            return JSON.JSONNull
        case let value as Bool:
            return JSON.JSONBool(value)
        case let value as NSNumber:
            return JSON.JSONNumber(value)
        case let value as String:
            return JSON.JSONString(value)
        case let value as NSDictionary:
            var JSONDictionary: [String:JSON] = [:]
            for(k, v): (AnyObject, AnyObject) in value {
                if let k = k as? String {
                    if let v = JSON.fromObject(v) {
                        JSONDictionary[k] = v
                    }
                }
            }
            return JSON.JSONDictionary(JSONDictionary)
        case let value as NSArray:
            var jsonArray : [JSON] = []
            for v in value {
                if let v = JSON.fromObject(v) {
                    jsonArray.append(v)
                }
            }
            return JSON.JSONArray(jsonArray)
        default:
            return nil
        }
    }
}