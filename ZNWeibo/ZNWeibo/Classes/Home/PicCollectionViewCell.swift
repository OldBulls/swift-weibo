//
//  PicCollectionViewCell.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/13.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var picView: UIImageView!
    
    
    var picURL :NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            picView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
}
