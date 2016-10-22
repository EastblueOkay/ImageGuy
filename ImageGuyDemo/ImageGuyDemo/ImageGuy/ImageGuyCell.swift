//
//  ImageGuyCell.swift
//  ImageGuyDemo
//
//  Created by 兰轩轩 on 2016/10/21.
//  Copyright © 2016年 兰轩轩. All rights reserved.
//

import UIKit
/// 如果使用CocoaPods 需要import Kingfisher
//import Kingfisher

class ImageGuyCell: UICollectionViewCell {
    
    
    /// 占位图asset String，UIImage
    open var placeHolder : Any?
    
    //MARK: - 公有变量
    open var imageUrlString : String?{
        didSet{
            //清空scrollView subviews
            for view in self.scrollView.subviews{
                view.removeFromSuperview()
            }
            
            let imageView = UIImageView()
            
            imageView.isUserInteractionEnabled = false
            imageView.contentMode = .scaleAspectFit
            imageView.frame = scrollView.bounds
            scrollView.addSubview(imageView)
            
            imageView.kf.setImage(with: URL(string: imageUrlString!), placeholder: placeholderImage(), options: nil, progressBlock: { [unowned self] (receive, total)->() in
                self.loadingView.isHidden = false
                let progress = CGFloat(receive) / CGFloat(total)
                self.loadingView.progress = progress
            }) { (image, error, cacheType, url) in
                if error != nil{
                    self.loadingView.isHidden = true
                    return
                }
                self.loadingView.isHidden = true
                if let image = image{
                    let width = self.contentView.frame.size.width
                    let height = width / image.size.width * image.size.height
                    imageView.frame.size = CGSize(width: width, height: height)
                    
                    if height > self.contentView.frame.height{
                        imageView.frame.origin.y = 0
                    }else{
                        imageView.center = self.scrollView.center
                    }
                    //调整image宽
                    self.scrollView.contentSize = imageView.frame.size
                }
                
            }
            
        }
    }
    
    /// 点击事件回调
    open var clickFunction : (()->())?
    
    //MARK: - 私有变量
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame: self.contentView.bounds)
        view.backgroundColor = UIColor.darkGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapScrollView))
        view.addGestureRecognizer(tap)
        
        view.delegate = self
        view.minimumZoomScale = 0.5
        view.maximumZoomScale = 2.0
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    fileprivate lazy var loadingView : LoadingView = {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        let view = LoadingView(frame: rect)
        view.center = self.contentView.center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        contentView.addSubview(loadingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - UIScrollViewDelegate
extension ImageGuyCell : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        /// 保证左右两张图片的滑动流畅 合并
        let image = scrollView.subviews.first!
        let contentSize = scrollView.contentSize
        
        var x = contentSize.width / 2
        var y = contentSize.height / 2
        if contentSize.height < scrollView.frame.height{
            y = scrollView.frame.height / 2
        }
        if contentSize.width < scrollView.frame.width{
            x = scrollView.frame.width / 2
        }
        image.center = CGPoint(x: x, y: y)
    }
    
}


// MARK: - 手势相关
extension ImageGuyCell : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc fileprivate func tapScrollView(){
        // 取消下载任务
        let imageView = scrollView.subviews.first as! UIImageView
        imageView.kf.cancelDownloadTask()
        clickFunction?()
    }
}

// MARK: - 私有方法
extension ImageGuyCell{

    /// 占位，asset String，UIImage
    fileprivate func placeholderImage() -> UIImage?{
        guard let holder = placeHolder else{
            return nil
        }
        if ((holder as AnyObject).isKind(of: UIImage.self)){
            return (placeHolder as! UIImage)
        }else{
            return UIImage(named: placeHolder as! String)
        }
    }
    
    
}
