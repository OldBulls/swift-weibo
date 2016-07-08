//
//  MessageViewController.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/6.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.setupVisitorViewInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }


}