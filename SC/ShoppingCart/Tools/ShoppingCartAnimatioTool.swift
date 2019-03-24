//
//  ShoppingCartAnimatioTool.swift
//  NiuGeYinSwift
//
//  Created by lujianqiao on 2018/8/13.
//  Copyright © 2018年 NGY. All rights reserved.
//



import UIKit
typealias animationFinishedBlock = (_ finish : Bool) -> Void

class ShoppingCartAnimatioTool: NSObject,CAAnimationDelegate {
    
    private var layer : CALayer?
    var aniFinishedBlock : animationFinishedBlock?
    override init() {
        super.init()
    }
    //MARK: - 开始走的方法
    func startAnimation(view : UIView,andRect rect : CGRect,andFinishedRect finishPoint : CGPoint, andFinishBlock completion : @escaping animationFinishedBlock) -> Void{
        layer = CALayer()
        layer?.contents = view.layer.contents
        layer?.contentsGravity = CALayerContentsGravity.resize
        layer?.frame = rect
        
        let myWindow : UIView = ((UIApplication.shared.delegate?.window)!)!
        myWindow.layer.addSublayer(layer!)
        //创建路径 其路径是抛物线
        let path : UIBezierPath = UIBezierPath()
        path.move(to: (layer?.position)!)
        path.addQuadCurve(to: finishPoint, controlPoint:CGPoint(x: myWindow.frame.size.width/2, y: rect.origin.y - 40))
        
        //这里要使用组合动画 一个负责旋转，另一个负责曲线的运动
        //创建 关键帧动画 负责曲线的运动
        let pathAnimation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")//位置的平移
        pathAnimation.path = path.cgPath
        //负责旋转 rotation
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        basicAnimation.isRemovedOnCompletion = true
        basicAnimation.fromValue = NSNumber(value: 0)
        basicAnimation.toValue = NSNumber(value:  2 * Double.pi)//这里是旋转的角度 共是：3圈 （2 * M_PI）是一圈
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        //缩小动画
        let scalAnimation = CABasicAnimation(keyPath: "transform.scale")
        scalAnimation.isRemovedOnCompletion = true
        scalAnimation.fromValue = NSNumber(floatLiteral: 1)
        scalAnimation.toValue = NSNumber(floatLiteral: 0.2)
        scalAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        
        //创建组合动画 主要是负责时间的相关设置 如下
        let groups : CAAnimationGroup = CAAnimationGroup()
        groups.animations = [pathAnimation,basicAnimation,scalAnimation]
        groups.duration = 1//国际单位制 S
        groups.fillMode = CAMediaTimingFillMode.forwards
        groups.isRemovedOnCompletion = false
        groups.delegate = self
        self.layer?.add(groups, forKey: "groups")
        aniFinishedBlock = completion
    }
    
    //MARK: - 上下浮动
    func shakeAnimation(shakeView : UIView){
        let basicAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        basicAnimation.duration = 0.25
        basicAnimation.fromValue = NSNumber(value: -5)
        basicAnimation.toValue = NSNumber(value: 5)
        basicAnimation.autoreverses = true
        shakeView.layer.add(basicAnimation, forKey: "Asong")
    }
    //MARK: -CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == layer!.animation(forKey: "groups"){
            layer?.removeFromSuperlayer()
            layer = nil
            if (aniFinishedBlock != nil) {
                aniFinishedBlock!(true)
            }
        }
    }
    
}

