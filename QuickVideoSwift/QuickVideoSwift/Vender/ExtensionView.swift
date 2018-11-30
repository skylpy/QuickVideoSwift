//
//  ExtensionView.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/26.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit
import AVKit

//高效绘制圆角UIImageView
extension UIImageView{
    
    func setCornerImage(){
        //异步绘制图像
        DispatchQueue.global().async(execute: {
            //1.建立上下文
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
            //获取当前上下文
            let ctx = UIGraphicsGetCurrentContext()
            //设置填充颜色
            UIColor.white.setFill()
            UIRectFill(self.bounds)
            //2.添加圆及裁切
            ctx?.addEllipse(in: self.bounds)
            //裁切
            ctx?.clip()
            //3.绘制图像
            self.draw(self.bounds)
            //4.获取绘制的图像
            let image = UIGraphicsGetImageFromCurrentImageContext()
            //5关闭上下文
            UIGraphicsEndImageContext()
            DispatchQueue.main.async(execute: {
                self.image = image
            })
        })
    }
}
    
    
   
    
extension UIImage {
    
    class func thumbnailImageForVideo(URL videoURL:String) -> UIImage{
        
        if videoURL.isEmpty {
            //默认封面图
            return UIImage(named: "icoNoInternet")!
        }
        let aset = AVURLAsset(url: URL(fileURLWithPath: videoURL), options: nil)
        let assetImg = AVAssetImageGenerator(asset: aset)
        assetImg.appliesPreferredTrackTransform = true
        assetImg.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        do{
            let cgimgref = try assetImg.copyCGImage(at: CMTime(seconds: 10, preferredTimescale: 50), actualTime: nil)
            return UIImage(cgImage: cgimgref)
            
            
        }catch{
            return UIImage(named: "icoNoInternet")!
        }
    }
}

//MARK: 数组的扩展
extension Array {
    subscript (wcl_safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
    
    @discardableResult
    mutating func wcl_removeSafe(at index: Int) -> Bool {
        if (0..<count).contains(index) {
            self.remove(at: index)
            return true
        }
        return false
    }
}


extension UIView {
    
    public var ld_x: CGFloat {
        get {
            return self.frame.origin.x
            
        }
        set(newVal) {
            var ld_frame: CGRect = self.frame
            ld_frame.origin.x = newVal
            self.frame = ld_frame
            
        }
        
    }
    
    public var ld_y: CGFloat {
        get {
            return self.frame.origin.y
            
        }
        set(newVal) {
            var ld_frame: CGRect = self.frame
            ld_frame.origin.y = newVal
            self.frame = ld_frame
            
        }
        
    }
    
    public var ld_width: CGFloat {
        get {
            return self.frame.size.width
            
        }
        set(newVal) {
            var ld_frame: CGRect = self.frame
            ld_frame.size.width = newVal
            self.frame = ld_frame
            
        }
        
    }

    public var ld_right: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.width
            
        }
        set(newVal) {
            var ld_frame: CGRect = self.frame
            ld_frame.size.width = newVal
            self.frame = ld_frame
            
        }
        
    }
    
    public var ld_height: CGFloat {
        get {
            return self.frame.size.height
            
        }
        set(newVal) {
            var ld_frame: CGRect = self.frame
            ld_frame.size.height = newVal
            self.frame = ld_frame
            
        }
        
    }
    
    public var ld_size: CGSize {
        get {
            return self.frame.size
            
        }
        set(newVal) {
            var ld_frame: CGRect = self.frame
            ld_frame.size = newVal
            self.frame = ld_frame
            
        }
        
    }
    
    public var ld_centerX: CGFloat {
        get {
            return self.center.x
            
        }
        set(newVal) {
            var ld_center: CGPoint = self.center
            ld_center.x = newVal
            self.center = ld_center
            
        }
        
    }
    
    public var ld_centerY: CGFloat {
        get {
            return self.center.y
            
        }
        set(newVal) {
            var ld_center: CGPoint = self.center
            ld_center.y = newVal
            self.center = ld_center
            
        }
        
    }
    
}

