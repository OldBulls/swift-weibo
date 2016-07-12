//
//  HomeViewController.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/6.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK:- 懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
    
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self?.titleBtn.selected = presented
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        //添加转盘动画
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        
        // 设置导航栏的内容
        setupNavigationBar()
    }
}

// MARK:- 设置UI界面
extension HomeViewController {
    private func setupNavigationBar() {
        // 1.设置左侧的Item
        /*
         let leftBtn = UIButton()
         leftBtn.setImage(UIImage(named: "navigationbar_friendattention"), forState: .Normal)
         leftBtn.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), forState: .Highlighted)
         leftBtn.sizeToFit()
         */
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        // 2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 3.设置titleView
        titleBtn.setTitle("臻牛科技", forState: .Normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
}


// MARK:- 事件监听的函数
extension HomeViewController {
    @objc private func titleBtnClick(titleBtn : TitleButton) {
        // 1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 2.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .Custom
        
        // 3.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        
        popoverAnimator.presentedFrame = CGRect(x: UIScreen.mainScreen().bounds.size.width * 0.5 - 90, y: 60, width: 180, height: 250)
        
        // 4.弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

extension HomeViewController {
    private func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            if error != nil {
                ZNLog(error)
                return
            }
            
            guard let resultArray = result else {
                return
            }
            
            
        }
    }
}
