//
//  ImageGuyViewController.swift
//  ImageGuyDemo
//
//  Created by 兰轩轩 on 2016/10/21.
//  Copyright © 2016年 兰轩轩. All rights reserved.
//

import UIKit

private let ImageGuyViewControllerCellIdentify = "ImageGuyViewControllerCellIdentify"

class ImageGuyViewController: UIViewController {

    //MARK: - 外部接口

    /// 每张图片对应一个Image占位图（[UIImage]）
    open var placeHolderImages : [UIImage]?
    
    /// 对应的Image占位图（UIImage）
    open var placeHolderImage : UIImage?
    
    //MARK: - 私有变量
    fileprivate var imageUrlStrings : [String]!
    fileprivate var initIndex : Int!
    
    //MARK: - 懒加载 （控件）
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.backgroundColor = UIColor.clear
        view.register(ImageGuyCell.self, forCellWithReuseIdentifier: ImageGuyViewControllerCellIdentify)
        return view
    }()
    
    /// 滚动图片进度条
    fileprivate lazy var progressView : UIProgressView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 3)
        let view = UIProgressView(progressViewStyle: .bar)
        view.frame = rect
        view.progressTintColor = UIColor(red:0.56, green:0.07, blue:1.00, alpha:1.00)
        view.tintColor = UIColor.black
        return view
    }()
    
    /// 
    fileprivate lazy var numberLabel : UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 80, height: 30)
        label.center = CGPoint(x: self.view.frame.width / 2, y: 50)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.backgroundColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:0.6)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "1 / \(self.imageUrlStrings.count)"
        return label
    }()
    
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    //MAKR: - 初始化
    
    /// ImageGuyViewController初始化方法
    ///
    /// - parameter urlStrings:   图片的urlString地址
    /// - parameter currentIndex: 选中的索引 （默认为1）
    ///
    /// - returns: ImageGuyViewController
    init(urlStrings : [String], currentIndex : Int = 0) {
        imageUrlStrings = urlStrings
        initIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// 处理initIndex
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offset = CGPoint(x: collectionView.frame.width * CGFloat(initIndex), y: 0)
        collectionView.setContentOffset(offset, animated: false)
        scrollViewDidScroll(collectionView)
        scrollViewDidEndDecelerating(collectionView)
    }
    
}


// MARK: - UI相关
extension ImageGuyViewController{

    /// 初始化UI
    fileprivate func setupUI(){
        view.backgroundColor = UIColor.darkGray
        view.addSubview(collectionView)
        view.addSubview(progressView)
        view.addSubview(numberLabel)
    }
    
}


// MARK: - UICollectionViewDataSource
extension ImageGuyViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGuyViewControllerCellIdentify, for: indexPath) as! ImageGuyCell
        
        // 赋值占位图片
        if (placeHolderImages?.count) ?? 0 > 0{
            cell.placeHolder = placeHolderImages?[indexPath.item] as NSObject?
        }else if (placeHolderImage != nil){
            cell.placeHolder = placeHolderImage
        }
        
        cell.imageUrlString = imageUrlStrings[indexPath.item]
        
        cell.clickFunction = {[unowned self] ()->() in
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
    
}


// MARK: - 处理序列| 点击事件 相关操作
extension ImageGuyViewController : UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percent = scrollView.contentOffset.x / (scrollView.contentSize.width -  scrollView.frame.width)
        progressView.setProgress(Float(percent), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let path = collectionView.indexPathForItem(at: CGPoint(x: scrollView.contentOffset.x, y: 0))
        numberLabel.text = "\((path?.item)! + 1) / \(imageUrlStrings.count)"
    }
    
}
