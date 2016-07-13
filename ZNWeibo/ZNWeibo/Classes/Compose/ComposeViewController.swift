//
//  ComposeViewController.swift
//  ZNWeibo
//
//  Created by 金宝和信 on 16/7/13.
//  Copyright © 2016年 zn. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // MARK:- 懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    @IBOutlet weak var picPickerView: PicPickerCollectionView!

    @IBOutlet weak var textView: ComposeTextView!
    
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var picPicerViewHCons: NSLayoutConstraint!
    
    private lazy var images : [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        setupNavigationBar()
        
        // 监听通知
        setupNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        textView.becomeFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK:- 设置UI界面
extension ComposeViewController {
    
    private func setupNavigationBar() {
        // 1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 2.设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    private func setupNotifications() {
        // 监听键盘的弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 监听添加照片的按钮的点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.addPhotoClick), name: PicPickerAddPhotoNote, object: nil)
        
        // 监听删除照片的按钮的点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("removePhotoClick:"), name: PicPickerRemovePhotoNote, object: nil)
    }
}

// MARK:- 事件监听函数
extension ComposeViewController {
    
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick() {
        print("sendItemClick")
    }
    
    @objc private func keyboardWillChangeFrame(note : NSNotification) {
        // 1.获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        // 2.获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = endFrame.origin.y
        
        // 3.计算工具栏距离底部的间距
        let margin = UIScreen.mainScreen().bounds.height - y
        
        // 4.执行动画
        toolBarBottomCons.constant = margin
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick() {
        // 退出键盘
        textView.resignFirstResponder()
        
        // 执行动画
        picPicerViewHCons.constant = UIScreen.mainScreen().bounds.height * 0.65
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
}

// MARK:- 添加照片和删除照片的事件
extension ComposeViewController {
    @objc private func addPhotoClick() {
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        // 2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        // 3.设置照片源
        ipc.sourceType = .PhotoLibrary
        
        // 4.设置代理
        ipc.delegate = self
        
        // 弹出选择照片的控制器
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    @objc private func removePhotoClick(note : NSNotification) {
        // 1.获取image对象
        guard let image = note.object as? UIImage else {
            return
        }
        
        // 2.获取image对象所在下标值
        guard let index = images.indexOf(image) else {
            return
        }
        
        // 3.将图片从数组删除
        images.removeAtIndex(index)
        
        // 4.重写赋值collectionView新的数组
        picPickerView.images = images
    }
}

// MARK:- UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1.获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 2.将选中的照片添加到数组中
        images.append(image)
        
        // 3.将数组赋值给collectionView,让collectionView自己去展示数据
        picPickerView.images = images
        
        // 4.退出选中照片控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
}

// MARK:- UITextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}