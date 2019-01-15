//
//  PayMethodViewController.swift
//  oasis
//
//  Created by Leon King on 9/1/15.
//  Copyright (c) 2015 Qinyejun. All rights reserved.
//

import UIKit

enum PaymentType {
    case Alipay,Weichat
}

protocol PayMethodViewControllerDelegate: class {
    func paymentSuccess(paymentType paymentType:PaymentType)
    func paymentFail(paymentType paymentType:PaymentType)
}


class PaymentViewController: UIViewController,WXApiDelegate {
    var order:MyOrder!
    weak var delegate:PayMethodViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 通常是请求服务器 API 生成订单，这里为测试方便直接将测试数据hardcode
        order = MyOrder(id: 2, title: "测试订单标题", content: "订单描述内容", url: "", createdAt: "", price: 0.01, paid: true, productID: 100);

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PaymentViewController.weixinPaySuccess(_:)), name: WXPaySuccessNotification, object: nil)
    }
    
    @IBAction func alipayAction(sender: AnyObject) {
        
        let aliOrder = AlipayOrder(partner: AlipayPartner, seller: AlipaySeller, tradeNO: order.id, productName: order.title, productDescription: order.content, amount: order.price, notifyURL: AlipayNotifyURL, service: "mobile.securitypay.pay", paymentType: "1", inputCharset: "utf-8", itBPay: "30m", showUrl: "m.alipay.com", rsaDate: nil, appID: nil)
        
        
        let orderSpec = aliOrder.description //orderA.description
        
        let signer = RSADataSigner(privateKey: AlipayPrivateKey)
        let signedString = signer.signString(orderSpec)
        
        let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""
        
        print(orderString)
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: AppScheme, callback: {[weak self] resultDic in
            if let strongSelf = self {
                print("Alipay result = \(resultDic as Dictionary)")
                let resultDic = resultDic as Dictionary
                if let resultStatus = resultDic["resultStatus"] as? String {
                    if resultStatus == "9000" {
                        strongSelf.delegate?.paymentSuccess(paymentType: .Alipay)
                        let msg = "支付成功！"
                        let alert = UIAlertView(title: nil, message: msg, delegate: nil, cancelButtonTitle: "好的")
                        alert.show()
                        //strongSelf.navigationController?.popViewControllerAnimated(true)
                    } else {
                        strongSelf.delegate?.paymentFail(paymentType: .Alipay)
                        let alert = UIAlertView(title: nil, message: "支付失败，请您重新支付！", delegate: nil, cancelButtonTitle: "好的")
                        alert.show()
                    }
                }
            }
            })
        
    }
    
    @IBAction func weichatPayAction(sender: AnyObject) {
        DataService.wxPrePay(order.id) {[weak self] (prepay, error) -> () in
            if let strongSelf = self {
                if let prepay = prepay {
                    let req = PayReq()
                    req.openID = prepay.appID
                    req.partnerId = prepay.partnerID
                    req.prepayId = prepay.prepayID
                    req.nonceStr = prepay.noncestr
                    req.timeStamp = UInt32(prepay.timestamp)
                    req.package = prepay.package
                    req.sign = prepay.sign
                    WXApi.sendReq(req)
                    
                    print("appid=\(req.openID)\npartid=\(req.partnerId)\nprepayid=\(req.prepayId)\nnoncestr=\(req.nonceStr)\ntimestamp=\(req.timeStamp)\npackage=\(req.package)\nsign=\(req.sign)");
                } else {
                    strongSelf.delegate?.paymentFail(paymentType: .Weichat)
                    let alert = UIAlertView(title: nil, message: "获取支付信息失败，请重新支付！", delegate: nil, cancelButtonTitle: "好的")
                    alert.show()
                }
            }
        }
    }
    
    
    func weixinPaySuccess(notification: NSNotification) {
        print("pay success")
    }
    
}
