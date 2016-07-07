//
//  VisitorView.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/8.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    // MARK:- 提供快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }

}
