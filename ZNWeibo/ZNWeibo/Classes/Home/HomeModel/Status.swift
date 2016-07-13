
//
//  Status.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/12.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class Status: NSObject {

    var created_at : String?                        // 微博创建时间
    var source : String?                            // 来源
    var text : String?                              // 正文
    var mid : Int = 0                               // 微博的ID
    var user : User?                                //用户信息
    var pic_urls : [[String : String]]?    //配图URL数组
    
    // MARK: -自定义构造函数
    init(dict : [String :AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        //将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
