//
//  HomeViewCell.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/13.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var sreenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bottomToolView: UIView!
    
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetContentCons: NSLayoutConstraint!
    @IBOutlet weak var retweetContentLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var picView: PicCollectionView!
    
    var viewModel : StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            iconView.sd_setImageWithURL(viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            verifiedView.image = viewModel.verifiedImage
            sreenNameLabel.text = viewModel.status?.user?.screen_name
            vipView.image = viewModel.vipImage
            timeLabel.text = viewModel.createAtText
            
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 \(sourceText)"
            } else {
                sourceLabel.text = nil
            }
            
            contentLabel.text = viewModel.status?.text
            sreenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
            
            // 获取图片大小
            let picViewSize = calculatePctViewSize(viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            //正文配图数组
            picView.picURLs = viewModel.picURLs
            
            // 设置转发微博正文
            if viewModel.status?.retweeted_status != nil {
                
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, retwttwedText = viewModel.status?.retweeted_status?.text {
                    retweetContentCons.constant = 15
                    retweetContentLabel.text = "@" + "\(screenName): " + retwttwedText
                    
                    bgView.hidden = false
                }
                
            } else {
                retweetContentCons.constant = 0
                retweetContentLabel.text = nil
                bgView.hidden = true
            }
            
            if viewModel.cellHeight == 0 {
                
                //强制布局
                layoutIfNeeded()
                
                viewModel.cellHeight = CGRectGetMaxY(bottomToolView.frame)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLabelWCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        
    }
}

extension HomeViewCell {
    private func calculatePctViewSize(count : Int) -> CGSize {
        
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSizeZero
        }
        
        picViewBottomCons.constant = 10
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumInteritemSpacing = 0
        
        // 3.单张配图
        if count == 1 {
            
            // 1.取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString)
            
            // 2.设置一张图片是layout的itemSize
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }

        let imageViewWH = ((UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin)) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 其他张配图
        let rows = CGFloat((count - 1) / 3 + 1)
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        let picViewW = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        return CGSize(width: picViewW, height: picViewH)
        
    }
}
