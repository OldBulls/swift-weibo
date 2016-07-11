//
//  AppDelegate.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/6.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit
import QorumLogs //第三方打印log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaultViewController :UIViewController? {
        
        let isLogin = UserAccountViewModel.shareIntance.isLogin
    
        return isLogin ? WelcomeViewController() : MainViewController()
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        QorumLogs.enabled = true
//        QorumLogs.test()
        
        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        //创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

//MARK: - 自定义全局Log 
func ZNLog<T>(message:T, fileName:String = #file, funcName:String = #function, lineNum:Int = #line) {
    
    #if DEBUG
        
        //添加flat标签步骤:点击项目-->Build Setting-->swfit flag-->点击箭头-->点击Debug添加--> -D DEBUG
        
        //lastPathComponent 获取字符串最后一个 "/"后面的字符串
        var file = (fileName as NSString).lastPathComponent as NSString
        let index = file.rangeOfString(".")
        file = file.substringToIndex(index.location)
        
        print("\(file):\(funcName)(\(lineNum)行)-\(message)")
        
    #endif
    
}





