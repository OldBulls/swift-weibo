//
//  PicCollectionView.swift
//  ZNWeibo
//
//  Created by 臻牛 on 2016/7/13.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {

    var picURLs : [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        
        registerNib(UINib(nibName: "PicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PicCell")
    }
    
}

extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicCell", forIndexPath: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLs[indexPath.row]
        
        return cell
    }
    
}