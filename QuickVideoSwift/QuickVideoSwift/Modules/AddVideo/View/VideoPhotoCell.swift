//
//  VideoPhotoCell.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/28.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit
import SnapKit

class VideoPhotoCell: UICollectionViewCell {
    
    var model = ContestChooseVideo.Video(){
        
        didSet{
            
            iconImage.image = model.image
            timeLabel.text = String(format: "%.2f", model.duration!/60)
        }
        
    }
    
    lazy var selectButton:UIButton = {
        let sButton = UIButton.init(type: .custom)
        sButton.setImage(LoadImage("Oval"), for: .normal)
        sButton.setImage(LoadImage("icon_point_tips"), for: .selected)
        sButton.setTitleColor(UIColor.white, for: .normal)
        sButton.sizeToFit()
        
        return sButton
    }()
    
    lazy var timeLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.font = UIFont.init(fontName: kRegFont, size: 12)
        return label
    }()
    
    lazy var iconImage:UIImageView = {
        let iocn = UIImageView.init(frame: self.bounds)
        iocn.contentMode = .scaleToFill
        iocn.layer.cornerRadius = 2
        iocn.clipsToBounds = true
        return iocn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.addSubview(iconImage)
        self.addSubview(selectButton)
        self.addSubview(timeLabel)
        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-5)
            make.top.equalTo(self.snp.top).offset(5)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    
}
