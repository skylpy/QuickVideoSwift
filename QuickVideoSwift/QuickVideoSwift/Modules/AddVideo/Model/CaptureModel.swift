//
//  CaptureModel.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/27.
//  Copyright © 2018年 aaron. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Photos

class CaptureModel: NSObject {
    
    ///取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>!
    
    ///缩略图大小
    var assetGridThumbnailSize:CGSize!
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    //获取相册中最新的一张照片
    class func getPreLastImage(b button:UIButton) {
        
        let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        var image:UIImage! = nil
        
        for index in 0..<smartAlbums.count {
            
            let collection:PHCollection = smartAlbums[index]
            
            if collection.isKind(of: PHAssetCollection.self){
                
                let fetchResult:PHFetchResult = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: nil)
                var asset:PHAsset? = nil;
                
                if fetchResult.count != 0 {
                    asset = fetchResult[0]
                    let imageManager:PHImageManager = PHImageManager.init()
                    imageManager.requestImage(for: asset!, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { (result, info) in

                        if ((result) != nil && index == 0) {
                            button .setImage(result, for: .normal)
                        }
                    }
                    
                }
                
                
            }else {
                
                print("NO")
            }
            
        }
        
    }
    
    
    ///打开闪光灯的方法
    class func openLight(open:Bool){
        let device:AVCaptureDevice = AVCaptureDevice.default(for: .video)!
        if !device.hasTorch{
            
            UIAlertView(title: "提示", message:"闪光灯故障", delegate:nil, cancelButtonTitle: "确定").show()
            
        }else{
            
            if open {//打开
                
                if  device.torchMode != AVCaptureDevice.TorchMode.on || device.flashMode != AVCaptureDevice.FlashMode.on{
                    
                    do{
                        try device.lockForConfiguration()
                        device.torchMode = AVCaptureDevice.TorchMode.on
                        device.flashMode = AVCaptureDevice.FlashMode.on
                        device.unlockForConfiguration()
                        
                    }catch{
                        print(error)
                    }
                }
            }else{//关闭闪光灯
                
                if  device.torchMode != AVCaptureDevice.TorchMode.off || device.flashMode != AVCaptureDevice.FlashMode.off{
                    
                    do{
                        try device.lockForConfiguration()
                        device.torchMode = AVCaptureDevice.TorchMode.off
                        device.flashMode = AVCaptureDevice.FlashMode.off
                        device.unlockForConfiguration()
                    }catch {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    ///判断闪光灯是否打开
    
    class func isLightOpened()->Bool{
        
        let device:AVCaptureDevice = AVCaptureDevice.default(for: .video)!
        
        if !device.hasTorch{
            
            return false
        }else{
            if device.torchMode == AVCaptureDevice.TorchMode.on {//闪光灯已经打开
                
                return true
                
            }else{
                
                return false
            }
        }
    }

    /// 从相册中获取视频数组----**-
    class func getVideosFromAlbum(result: @escaping (([ContestChooseVideo.Video]) -> Void)){
        var videos: [ContestChooseVideo.Video] = []
        // 获取所有资源的集合，并按资源的创建时间排序如果不写就是乱序,并不好使
        // let options = PHFetchOptions()
        // options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let option = PHVideoRequestOptions()
        option.version = .current
        option.deliveryMode = .automatic
        option.isNetworkAccessAllowed = true
        let manager = PHImageManager.default()
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .video, options: nil)
        var tempCount = assets.count
        // 获取视频
        for i in 0..<assets.count {
            let asset = assets.object(at: i)
            manager.requestAVAsset(forVideo: asset, options: option) {
                (avasset, audioMix, array) in
                // 为了防止多次回调
                tempCount = tempCount - 1
                guard let urlAsset: AVURLAsset = avasset as? AVURLAsset
                    else {
                        if tempCount == 0 {
//                            showFailure("获取视频失败")
                            result([])
                            
                        }
                        return
                        
                }
                var model = ContestChooseVideo.Video()
                model.asset = asset
                model.avSet = avasset
                model.videoUrl = urlAsset.url
                model.image = UIImage.thumbnailImageForVideo(URL: urlAsset.url.absoluteString)
                model.duration = CMTimeGetSeconds(urlAsset.duration)
                model.creationDate = asset.creationDate
                videos.append(model)
                if tempCount == 0 {
                    // 把视频按照日期排序
                    let newVideos = videos.sorted(by: { (video1, video2) -> Bool in
                        
                        guard let date1 = video1.creationDate,
                            let date2 = video2.creationDate else {
                                return true
                                
                        }
                        return date1 < date2
                        
                    })
                    result(newVideos)
                }
            }
        }
    }
    
   
}

enum ContestChooseVideo { }
extension ContestChooseVideo {
    struct Video {
        var image: UIImage? // 视频封面
        var duration: Double? // 视频时长
        var asset: PHAsset? // 操作信息的对象
        var videoUrl: URL? // 视频本地地址
        var avSet: AVAsset? // 剪辑控制
        var creationDate: Date? // 视频创建时间
        
    }
}
    
    

