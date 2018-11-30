//
//  LPYVideoTableViewController.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/27.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class LPYVideoTableViewController: UICollectionViewController {
    
    let reuseIdentifier:String = "VideoPhotoCell"
    lazy var dataArray:NSMutableArray = {
        let arr = NSMutableArray()
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(VideoPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model:ContestChooseVideo.Video = self.dataArray[indexPath.row] as! ContestChooseVideo.Video
        
        let cell:VideoPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoPhotoCell
        cell.model = model
        return cell
    }
    
    
}

extension LPYVideoTableViewController:YSMContainrerChildControllerDelegate{

    func childScrollView() -> UIScrollView! {
        
        return self.collectionView
    }

}
