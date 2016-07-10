//
//  UserAccount.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/9.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    
    /// 授权AccessToken
    var access_token : String?
    
    /// 过期时间－－>秒
    var expires_in : NSTimeInterval = 0.0
    
    /// 用户ID
    var uid : String?
    
    // MARK: - 字典转模型
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        return dictionaryWithValuesForKeys(["access_token", "expires_in", "uid"]).description
    }

}
