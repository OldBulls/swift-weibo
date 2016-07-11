//
//  UserAccount.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/9.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    /// 授权AccessToken
    var access_token : String?
    
    /// 过期时间－－>秒
    var expires_in : NSTimeInterval = 0.0 {
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 用户ID
    var uid : String?
    
    /// 获取日期
    var expires_date : NSDate?
    
    /// 头像
    var avatar_large : String?
    
    /// 昵称
    var screen_name : String?
    
    // MARK: - 字典转模型
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        return dictionaryWithValuesForKeys(["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
    
    /// MARK: - 归档解档
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
    }
    
    /// 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }

}
