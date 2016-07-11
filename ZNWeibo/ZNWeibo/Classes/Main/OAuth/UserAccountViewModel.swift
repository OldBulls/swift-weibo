//
//  UserAccountTools.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/10.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
    
    var  account : UserAccount?
    
    
    // MARK: - 计算属性
    var accountPath :String {
        
        //获取沙盒路径
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        ZNLog(accountPath)
        return (accountPath as NSString).stringByAppendingPathComponent("account.plist")
        
    }
    
    var isLogin : Bool {
        
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else {
            return false
        }
        
        return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending //降序
    }
    
    init() {
        
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
    
}
