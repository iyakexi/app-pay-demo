//
//  AppDelegate.swift
//  AppPayDemo
//
//  Created by Leon King on 1/29/16.
//  Copyright © 2016 QinYejun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WXApi.registerApp(WX_APPID, withDescription: "apppaydemo1.0")

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("openURL:\(url.absoluteString)")
        
        if url.scheme == WX_APPID {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        
        //跳转支付宝钱包进行支付，处理支付结果
        AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDict:[NSObject : AnyObject]!) -> Void in
            print("openURL result: \(resultDict)")
        })
        
        return true
    }
    
    func onResp(resp: BaseResp!) {
        var strTitle = "支付结果"
        var strMsg = "\(resp.errCode)"
        if resp.isKindOfClass(PayResp) {
            switch resp.errCode {
            case 0 :
                NSNotificationCenter.defaultCenter().postNotificationName(WXPaySuccessNotification, object: nil)
            default:
                strMsg = "支付失败，请您重新支付!"
                print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
            }
        }
        let alert = UIAlertView(title: nil, message: strMsg, delegate: nil, cancelButtonTitle: "好的")
        alert.show()
    }


}

