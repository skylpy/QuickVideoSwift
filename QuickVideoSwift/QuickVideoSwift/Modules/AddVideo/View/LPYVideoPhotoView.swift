//
//  LPYVideoPhotoView.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/27.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class LPYVideoPhotoView: UIView {
    
    lazy var cameraView:UIView = {
        let cview = UIView.init(frame: self.bounds);
        
        return cview
    }()
    
    lazy var model:AVFoundationModel = {
        let av = AVFoundationModel()
        
        return av
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(cameraView)
        model.setDrawUI(view: self, cv: cameraView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
