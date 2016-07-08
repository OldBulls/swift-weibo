//
//  UIBarButtonItem-Extension.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/8.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    /*
     convenience init(imageName : String) {
     self.init()
     
     let btn = UIButton()
     btn.setImage(UIImage(named: imageName), forState: .Normal)
     btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
     btn.sizeToFit()
     
     self.customView = btn
     }
     */
    
    convenience init(imageName : String) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        
        self.init(customView : btn)
    }
}