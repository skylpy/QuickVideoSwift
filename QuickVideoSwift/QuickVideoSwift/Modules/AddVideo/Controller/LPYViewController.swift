//
//  LPYViewController.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/27.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LPYViewController: UIView {
    
    var viewControllers:NSArray!
    private var disposeBag = DisposeBag()
    var child1:LPYVideoTableViewController?
    var child2:LPYPhotoTableViewController?
    
    lazy var containerView:YSMContainerView = {
        let cv = YSMContainerView.init(frame: self.bounds)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.headerHangingHeight = 90
        return cv
    }()
    
    lazy var cancelButton:UIButton = {
        let cButton = UIButton.init(type: .custom)
        cButton.frame = CGRect(x: 20, y: 30, width: 30, height: 30)
        cButton.setImage(LoadImage("closeIcon"), for: .normal)
        cButton.setTitleColor(UIColor.white, for: .normal)
        cButton.sizeToFit()
        
        return cButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(self.containerView)
        self.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(LPYViewController.cancel), for: .touchUpInside)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: KWidth/4-10, height: KWidth/4-10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        child1 = LPYVideoTableViewController.init(collectionViewLayout: layout)
        child2 = LPYPhotoTableViewController.init(collectionViewLayout: layout)
        
        self.viewControllers = [child1!,child2!];
        
        requestData()
    }
    
    func requestData() {
        
        CaptureModel.getVideosFromAlbum { (videos) in

            let group = DispatchGroup()
            let queueVideo = DispatchQueue(label: "video")
            
            queueVideo.async(group: group) {
                self.child1?.dataArray.removeAllObjects()
                for index in 0..<videos.count {
                    
                    let video:ContestChooseVideo.Video = videos[index]
                    
                    self.child1?.dataArray.add(video)
                    
                }
            }
            group.notify(queue: DispatchQueue.main) {
                self.child1?.collectionView.reloadData()
            }
        }
        
//        let groupp = DispatchGroup()
//        let queuePhoto = DispatchQueue(label: "photo")
//        queuePhoto.async(group: groupp) {
//            let pick = PickerManager()
//            
//            for index in 0..<pick.photoAlbums.count {
//
//                pick.getPHAsset(index, photoIndex: index) {
//                    pick.getPhotoDefalutSize(index, photoIndex: index, resultHandler: { (image, infoDic) in
//                        
//                    })
//                }
//
//            }
//        }
//        groupp.notify(queue: DispatchQueue.main) {
//            self.child2?.collectionView.reloadData()
//        }
        
        
    }
    
    
    var model = AVFoundationModel(){
        
        didSet{
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancel() {
        
        model.startCaptureSrssion()
        self.removeFromSuperview()
    }
}

extension LPYViewController:YSMContainerViewDataSource,YSMContainerViewDelegate{
    
    func titles(for containerView: YSMContainerView!) -> [String]! {
        
        return ["视频","相册"]
    }
    
    func numberOfViewControllers(in containerView: YSMContainerView!) -> Int {
        
        return self.viewControllers.count
    }
    
    
    func containerView(_ containerView: YSMContainerView!, viewControllerAt index: Int) -> (UIViewController & YSMContainrerChildControllerDelegate)! {
        
        let childController: UIViewController = self.viewControllers?[index] as! UIViewController
        
        return childController as? (UIViewController & YSMContainrerChildControllerDelegate)
    }
    
    func headerView(for containerView: YSMContainerView!) -> UIView! {
        
        let headerView = LPYVideoPhotoView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 180))
        headerView.backgroundColor = UIColor.clear

        return headerView
    }
    
}
