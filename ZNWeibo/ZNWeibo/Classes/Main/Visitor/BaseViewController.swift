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
    }

}

extension BaseViewController {
    private func setupVisitorView() {
        view = visitorView
    }
}
