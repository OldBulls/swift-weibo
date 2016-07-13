//
//  MainViewController.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/6.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        //创建控制器
        creatChildVc()
        
        //自定义tabBar
        setTabBar()
        
        //监听重复点击tabBar按钮的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.tabBarButtonDidRepeatClick), name: "ZNTabBarButtonDidRepeatClickNotification", object: nil)
        
    }
    
    //代替了 dealloc
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension MainViewController {
    
    
    private func creatChildVc() {
        
        //创建子控制器
        //方法1
        //        addChildViewController(HomeTableViewController(), title: "首页", imageName: "")
        //        addChildViewController(MessageTableViewController(), title: "消息", imageName: "")
        //        addChildViewController("DiscoverTableViewController", title: "发现", imageName: "")
        //        addChildViewController("ProfileTableViewController", title: "我", imageName: "")
        
        //方法二 通过json动态创建控制器
        //1.获取json路径
        guard let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else {
            ZNLog("没有获取到对应的文件路径")
            return
        }
        
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            ZNLog("没有获取到json文件数据")
            return
        }
        
        //3.将Data转成数组
        //MutableContainers 可变容器
        guard let anyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) else {
            return
        }
        
        guard let dictArray = anyObject  as? [[String : AnyObject]] else {
            return
        }
        
        for dict in dictArray {
            
            guard let vcName = dict["vcName"] as? String else {
                continue
            }
            
            guard let title = dict["title"] as? String else {
                continue
            }
            
            guard let imageName = dict["imageName"] as? String else {
                continue
            }
            
            addChildViewController(vcName, title: title, imageName: imageName)
        }
    }
    
    //方法重载:方法名相同,参数不同
    //private 只有当前文件能访问,其他文件不能访问
    /** 添加子控制器 */
    private func addChildViewController(childVc: UIViewController, title: String, imageName: String) {
        
        //设置子控制器属性
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //包装导航栏控制器
        let childNav = UINavigationController(rootViewController: childVc)
        
        //添加子控制器
        addChildViewController(childNav)
    }
    
    
    /** 通过类名创建添加子控制器 */
    private func addChildViewController(childVcName: String, title: String, imageName: String) {
        
        //0.获取命名空间
        guard let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            ZNLog("没有获取到命名空间")
            return
        }
        
        //1.获取对应Class
        
        guard let childVcClass = NSClassFromString(nameSpace + "." + childVcName) else {
            ZNLog("没有获取到字符串对应的Class")
            return
        }
        
        guard let childTpye = childVcClass as? UIViewController.Type else {
            ZNLog("没有获取对应控制器的类型")
            return
        }
        
        //3.创建对应的控制器
        let childVc = childTpye.init()
        
        //设置子控制器属性
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //包装导航栏控制器
        let childNav = UINavigationController(rootViewController: childVc)
        
        //添加子控制器
        addChildViewController(childNav)
    }
    
}

extension MainViewController {
    
    private func setTabBar() {
        //自定义tabBar
        let tabBar = ZNTabBar()
        setValue(tabBar, forKey: "tabBar")
        tabBar.plusButton.addTarget(self, action: #selector(MainViewController.plusButtonDidClick), forControlEvents: .TouchUpInside)
        
    }
    
}

extension MainViewController {
    
    @objc private func tabBarButtonDidRepeatClick() {
        
        if view.window == nil {
            return
        }
        
        ZNLog(#function)
    }
    
    @objc private func plusButtonDidClick() {
        
        let composeVc = ComposeViewController()
        let composeNav = UINavigationController(rootViewController: composeVc)
        presentViewController(composeNav, animated: true, completion: nil)
        
     
    }
}