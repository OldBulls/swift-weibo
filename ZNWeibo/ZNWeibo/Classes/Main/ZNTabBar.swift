//
//  ZNTabBar.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/7.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class ZNTabBar: UITabBar {

    var previousClickedTabBarButton : UIControl?
    lazy var plusButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let count = items?.count else {
            
            return
        }
        
        
        let btnW : CGFloat = frame.size.width / CGFloat(count + 1)
        let btnH : CGFloat = frame.size.height
        var x : CGFloat = 0
        var i = 0
        
        for tabBarButton in subviews {
            
            
            guard tabBarButton.isKindOfClass(NSClassFromString("UITabBarButton")!) else {
                
//                ZNLog("不是TabBarButton")
                continue
            }
            
            
            if i == 0 && previousClickedTabBarButton == nil {
                previousClickedTabBarButton = tabBarButton as? UIControl
            }
            
            if i == 2 {
                i += 1
            }
            
            x = CGFloat(i) * btnW
            tabBarButton.frame = CGRectMake(x, 0, btnW, btnH)
            
            i += 1
            
            (tabBarButton as! UIControl).addTarget(self, action: #selector(ZNTabBar.tabBarButtonClick(_:)), forControlEvents: .TouchUpInside)
        }
        
        
        plusButton.center = CGPointMake(center.x, bounds.size.height * 0.5)
        addSubview(plusButton)
    }
    
    @objc private func tabBarButtonClick(tabBarButton : UIControl) {
        
        if previousClickedTabBarButton == tabBarButton {
            NSNotificationCenter.defaultCenter().postNotificationName("ZNTabBarButtonDidRepeatClickNotification", object: nil)
        }
        previousClickedTabBarButton = tabBarButton
    }

}
