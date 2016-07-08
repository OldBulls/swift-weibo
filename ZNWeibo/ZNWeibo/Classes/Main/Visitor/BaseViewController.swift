//
//  BaseViewController.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/8.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    // MARK: - 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    var isLogin : Bool = false
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }
}

extension BaseViewController {
    
    //设置访客试图
    private func setupVisitorView() {
        view = visitorView
        
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), forControlEvents: .TouchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), forControlEvents: .TouchUpInside)
        
    }
    
    //设置导航栏左右的Item
    private func setupNavigationItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: .Plain, target: self, action: #selector(BaseViewController.loginBtnClick))
        
    }
}

extension BaseViewController {
    @objc private func registerBtnClick() {
        ZNLog("registerBtnClick")
    }
    
    @objc private func loginBtnClick() {
        ZNLog("loginBtnClick")
    }
}