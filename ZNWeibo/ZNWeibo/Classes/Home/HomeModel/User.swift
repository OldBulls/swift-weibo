//
//  User.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/12.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class User: NSObject {

    var profile_image_url : String?     // 小头像
    var screen_name : String?           //昵称
    var verified_type : Int = -1        //认证类型 -1是未认证
    var mbrank : Int = 0                //会员等级

    
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
