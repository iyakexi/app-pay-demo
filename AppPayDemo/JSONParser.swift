//
//  JSONParser.swift
//  AppPayDemo
//
//  Created by Leon King on 1/29/16.
//  Copyright © 2016 QinYejun. All rights reserved.
//

import Foundation

struct JSONParser {
    
    static func parsePrePay(json:JSON) -> WXPrePay {
        let appid:String = json["appid"]?.string ?? ""
        let noncestr:String = json["noncestr"]?.string ?? ""
        let package:String = json["package"]?.string ?? ""
        let partnerid:String = json["partnerid"]?.string ?? ""
        let prepayid:String = json["prepayid"]?.string ?? ""
        let sign:String = json["sign"]?.string ?? ""
        let timestamp:Int = json["timestamp"]?.integer ?? 0
        
        return WXPrePay(appID: appid, noncestr: noncestr, package: package, partnerID: partnerid, prepayID: prepayid, sign: sign, timestamp: timestamp)
    }
    
    static func parseOrder(json:JSON) -> MyOrder {
        let id:Int = json["id"]?.integer ?? 0
        let title:String = json["title"]?.string ?? ""
        let content:String = json["content"]?.string ?? ""
        let createdAt:String = json["createdAt"]?.string ?? ""
        let url:String = json["url"]?.string ?? ""
        let price:Double = json["price"]?.double ?? 0.0
        let paid:Bool = json["paid"]?.bool ?? false
        let pID:Int = json["refID"]?.integer ?? 0
        
        return MyOrder(id: id, title: title, content: content, url: url, createdAt: createdAt, price: price, paid: paid, productID: pID)
    }
    
}