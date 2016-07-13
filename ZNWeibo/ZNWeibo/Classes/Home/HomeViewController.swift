//
//  HomeViewController.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/6.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    // MARK:- 懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
    
    //提示label
    private lazy var tipLabel : UILabel = UILabel()
    
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self?.titleBtn.selected = presented
    }

    // 微博模型数组
    private lazy var ViewModels : [StatusViewModel] = [StatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //添加转盘动画
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        
        // 设置导航栏的内容
        setupNavigationBar()
        
        
        //根据约束自动计算
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        //估算高度
        tableView.estimatedRowHeight = 200
        
        
        //集成下拉刷新
        setupHeaderView()
        
        //上拉加载
        setupFooterView()
        
        //设置起始的tipLabel
        setupTipLabel()
        
        
    }
}

// MARK:- 设置UI界面
extension HomeViewController {
    
    //设置导航栏
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
    
    // 设置下拉刷新控件内容
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatus))
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("释放更新", forState: .Pulling)
        header.setTitle("加载中...", forState: .Refreshing)
        
        
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    
    //设置上拉加载控件
    private func setupFooterView() {
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatus))
    }
    
    //设置起始的tipLabel
    private func setupTipLabel() {
        
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.mainScreen().bounds.width, height: 32)
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.alpha = 0.8
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.textAlignment = .Center
        tipLabel.hidden = true
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
        
        popoverAnimator.presentedFrame = CGRect(x: UIScreen.mainScreen().bounds.width * 0.5 - 90, y: 60, width: 180, height: 250)
        
        // 4.弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

// MARK: - 请求数据
extension HomeViewController {
    
    //下拉刷新
    @objc private func loadNewStatus() {
        loadStatuses(true)
    }
    
    //上拉加载
    @objc private func loadMoreStatus() {
        loadStatuses(false)
    }
    
    // 加载微博数据
    private func loadStatuses(isNewNata : Bool) {
        
        var since_id = 0
        var max_id = 0
        
        if isNewNata {
            since_id = ViewModels.first?.status?.mid ?? 0
        } else {
            max_id = ViewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkTools.shareInstance.loadStatuses(since_id, max_id: max_id) { (result, error) in
            if error != nil {
                ZNLog(error)
                return
            }
            
            guard let resultArray = result else {
                return
            }
            
            //临时数组,存放最新的微博数据
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            if isNewNata {
                self.ViewModels = tempViewModel + self.ViewModels
                self.showTipLabel(tempViewModel.count)
            } else {
                self.ViewModels +=  tempViewModel
            }
            
            self.cacheImages(tempViewModel)
            
        }
    }
    
    // 下载图片
    private func cacheImages(viewModels : [StatusViewModel]) {
        // 0.创建group
        let group = dispatch_group_create()
        
        // 1.缓存图片
        for viewmodel in viewModels {
            for picURL in viewmodel.picURLs {
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _) -> Void in
                    ZNLog("下载了一张图片")
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 2.刷新表格
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            
            ZNLog("刷新表格")
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    // 显示提示的label
    private func showTipLabel(count : Int) {
        tipLabel.hidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条新微博"
        
        UIView.animateWithDuration(1.0, animations: {
            
            self.tipLabel.frame.origin.y = 44
            
            }) { (_) in
                
                UIView.animateWithDuration(1.0, delay: 1.5, options: [], animations: {
                    
                    self.tipLabel.frame.origin.y = 10
                    
                    }, completion: { (_) in
                        self.tipLabel.hidden = true
                })
        }
    }
}

// MARK: - tableView dataSource
extension HomeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ID = "HomeCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? HomeViewCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeViewCell", owner: nil, options: nil).first as? HomeViewCell
            ZNLog("tableView --\(indexPath.row)")
            
        }
        
        cell?.viewModel =  ViewModels[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let viewModel = ViewModels[indexPath.row]
        return viewModel.cellHeight
    }
    
    
}
