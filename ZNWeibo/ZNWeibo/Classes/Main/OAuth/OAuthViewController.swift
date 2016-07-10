//
//  OAuthViewController.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/9.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏的内容
        setupNavigationBar()
        
        // 2.加载网页
        loadPage()
    }
    
}


// MARK:- 设置UI界面相关
extension OAuthViewController {
    private func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    private func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        // 2.创建对应NSURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // 3.创建NSURLRequest对象
        let request = NSURLRequest(URL: url)
        
        // 4.加载request对象
        webView.loadRequest(request)
        webView.accessibilityLabel = "123"
    }
}



// MARK:- 事件监听函数
extension OAuthViewController {
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='18622612126';document.getElementById('passwd').value='zhenniu212';"
        
        // 2.执行js代码
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK:- webView的delegate方法
extension OAuthViewController : UIWebViewDelegate {
    // webView开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
//        SVProgressHUD.show()
    }
    
    // webView网页加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
//        SVProgressHUD.dismiss()
    }
    
    // webView加载网页失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
//        SVProgressHUD.dismiss()
    }
    
    
    // 当准备加载某一个页面时,会执行该方法
    // 返回值: true -> 继续加载该页面 false -> 不会加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取加载网页的NSURL
        guard let url = request.URL else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString
        
        // 3.判断该字符串中是否包含code
        guard urlString.containsString("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlString.componentsSeparatedByString("code=").last!
        ZNLog(code)
        
        //5.请求accessToken
        loadAccessToken(code)
        
        return false
    }
}


extension OAuthViewController {
    
    ///请求accessToken
    private func loadAccessToken(code : String) {
        NetworkTools.shareInstance.loadAccessToken(code) { (result, error) in
            //1.错误检查
            if error != nil {
                ZNLog(error)
                return
            }
            
            //2.拿到结果
            ZNLog(result)
            guard let accountDict = result else {
                
                ZNLog("没有获取授权后的结果")
                return
            }
            
            let account = UserAccount(dict: accountDict)
            ZNLog(account)
            
        }
    }
}
