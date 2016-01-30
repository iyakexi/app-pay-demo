//
//  AlipayOrder.swift
//  AppPayDemo
//
//  Created by Leon King on 1/29/16.
//  Copyright © 2016 QinYejun. All rights reserved.
//

import Foundation

struct AlipayOrder:CustomStringConvertible {
    let partner:String
    let seller:String
    let tradeNO:Int
    let productName:String
    let productDescription:String
    let amount:Double
    let notifyURL:String
    
    let service:String
    let paymentType:String
    let inputCharset:String
    let itBPay:String
    let showUrl:String
    
    let rsaDate:String? //optional
    let appID:String? //optional
    
    init(partner:String,
        seller:String,
        tradeNO:Int,
        productName:String,
        productDescription:String,
        amount:Double,
        notifyURL:String,
        service:String,
        paymentType:String,
        inputCharset:String,
        itBPay:String,
        showUrl:String,
        rsaDate:String?,
        appID:String?) {
            self.partner = partner
            self.seller = seller
            self.tradeNO = tradeNO
            self.productName = productName
            self.productDescription = productDescription
            self.amount = amount
            self.notifyURL = notifyURL
            self.service = service
            self.paymentType = paymentType
            self.inputCharset = inputCharset
            self.itBPay = itBPay
            self.showUrl = showUrl
            self.rsaDate = rsaDate
            self.appID = appID
    }
    
    var description:String {
        var desc = ""
        desc += "partner=\"\(partner)\""
        desc += "&seller_id=\"\(seller)\""
        desc += "&out_trade_no=\"\(tradeNO)\""
        desc += "&subject=\"\(productName)\""
        desc += "&body=\"\(productDescription)\""
        desc += "&total_fee=\"" + amount.format("0.2") + "\""
        desc += "&notify_url=\"\(notifyURL)\""
        desc += "&service=\"\(service)\""
        desc += "&payment_type=\"\(paymentType)\""
        desc += "&_input_charset=\"\(inputCharset)\""
        desc += "&it_b_pay=\"\(itBPay)\""
        desc += "&show_url=\"\(showUrl)\""
        
        if let rsaDate = rsaDate {
            desc += "&sign_date=\(rsaDate)"
        }
        
        if let appID = appID {
            desc += "&app_id=\(appID)"
        }
        
        return desc
    }
}