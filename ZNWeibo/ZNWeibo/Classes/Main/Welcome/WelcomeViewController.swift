//
//  WelcomeViewController.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/11.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
    
     // MARK: - 拖线的属性
    
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!

    @IBOutlet weak var iconView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileURLString = UserAccountViewModel.shareIntance.account?.avatar_large
        
        // ?? :如果前面的可选类型有值，那么将前面的可选类型进行解包并且赋值
        // 如果前面的可选类型为nil，那么直接使用？？后面的值
        let url = NSURL(string: profileURLString ?? "")
        
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big"))

        iconViewBottomCons.constant = UIScreen.mainScreen().bounds.height - 200
        
        // Damping:阻力系数，系数越大，弹动的效果越不明显 0～1
        // initialSpringVelocity ：初始化速度
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.77, initialSpringVelocity: 4.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
                UIApplication.sharedApplication().keyWindow?.rootViewController = MainViewController()
        }
        
    }
    


}
