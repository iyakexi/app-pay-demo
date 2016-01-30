//
//  WXPrePay.swift
//  AppPayDemo
//
//  Created by Leon King on 1/29/16.
//  Copyright © 2016 QinYejun. All rights reserved.
//

import Foundation

struct WXPrePay {
    let appID: String
    let noncestr: String
    let package: String
    let partnerID: String
    let prepayID: String
    let sign: String
    let timestamp: Int
    
    init(appID: String,
        noncestr: String,
        package: String,
        partnerID: String,
        prepayID: String,
        sign: String,
        timestamp: Int) {
            self.appID = appID
            self.noncestr = noncestr
            self.package = package
            self.partnerID = partnerID
            self.prepayID = prepayID
            self.sign = sign
            self.timestamp = timestamp
    }
}