//
//  LoadingView.swift
//  ImageGuyDemo
//
//  Created by 兰轩轩 on 2016/10/21.
//  Copyright © 2016年 兰轩轩. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    //MARK: - 公有变量
    
    /// 圆圈颜色
    open var color : UIColor = UIColor.gray{
        didSet{
            setNeedsDisplay()
        }
    }
    open var progress : CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
//        if progress >= 0.3{return}
        //外圈
        drawCircle(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), to: CGFloat(M_PI_2 * 3), rect: rect)
        //进度
        drawCircle(color: color, to: CGFloat(M_PI_2 * 2) * progress - CGFloat(M_PI_2), rect: rect)
        
    }
    
    
    /// 画一个圈
    ///
    /// - parameter color: 颜色
    /// - parameter from:  起始位置
    /// - parameter to:    结束为止
    fileprivate func drawCircle(color : UIColor, to : CGFloat, rect: CGRect){
        let width : CGFloat = 4
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setLineWidth(width)
        color.set()
        let radius = rect.size.width / 2 - width / 2
        ctx.setLineCap(.round)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        ctx.addArc(center: center, radius: radius, startAngle: -CGFloat(M_PI_2), endAngle: to, clockwise: false)
        ctx.strokePath()
    }
    
}
