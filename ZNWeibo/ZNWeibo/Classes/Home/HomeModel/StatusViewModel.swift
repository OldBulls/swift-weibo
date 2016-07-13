//
//  StatusViewModel.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/12.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    var status : Status?
    
    var sourceText : String?
    var createAtText : String?
    
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    var profileURL : NSURL?
    var picURLs : [NSURL] = [NSURL]()
    
    init(status : Status) {
        self.status = status
        
        // 1.处理时间数据
        if let created_at = status.created_at  {
            
            createAtText = NSDate.createDateString(created_at)
        }
        
        // 2.处理来源数据
        if let source = status.source where source != ""  {
            
            //处理来源字符串
            // <a href="http://weibo.com" rel="nofollow">新浪微博</a>
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - startIndex
            
            sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
        
        // 3.处理用户数据
        let verified_type = status.user?.verified_type ?? -1
        
        switch verified_type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 4.处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        
        if mbrank > 0 && mbrank <= 6 {
            
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        
        // 5.处理图像url
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = NSURL(string: profileURLString)
        
        
        //6.配图处理
        if let picURLDicts = status.pic_urls {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(NSURL(string : picURLString)!)
            }
        }
    }
}
