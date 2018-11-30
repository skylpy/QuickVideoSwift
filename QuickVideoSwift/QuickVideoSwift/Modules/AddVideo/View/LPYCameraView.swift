//
//  LPYCameraView.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/26.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LPYCameraViewDelegate: NSObjectProtocol {
    
    func cancelBack()
    func switchCamera()
    func light()
    
    func getLastPhoto(b button:UIButton)
    
    func takeVideo(b:UIButton)
}

class LPYCameraView: UIView {
    
    var type:NSInteger?
    weak var delegate:LPYCameraViewDelegate?
    private var disposeBag = DisposeBag()
    
    lazy var topView:UIView = {
        let tview = UIView.init(frame: CGRect(x: 0, y: 0, width: ld_width, height: 64))
        tview.backgroundColor = UIColor.clear
        return tview
    }()
    
    lazy var bottomView:UIView = {
        let bview = UIView.init(frame: CGRect(x: 0, y: ld_height-100, width: ld_width, height: 100))
        bview.backgroundColor = UIColor.clear
        return bview
    }()
    
    lazy var focusView:UIView = {
        let fview = UIView.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        fview.backgroundColor = UIColor.clear
        fview.layer.borderColor = UIColor.blue.cgColor
        fview.layer.borderWidth = 5.0
        fview.isHidden = true
        return fview
    }()
    
    lazy var exposureView:UIView = {
        let eview = UIView.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        eview.backgroundColor = UIColor.clear
        eview.layer.borderColor = UIColor.purple.cgColor
        eview.layer.borderWidth = 5.0
        eview.isHidden = true
        return eview
    }()
    
    lazy var previewView:CameraPreView = {
        let pview = CameraPreView.init(frame: CGRect(x: 0, y: 0, width: ld_width, height: ld_height-64-100))
        return pview
    }()
    
    lazy var photoButton:UIButton = {
        let pButton = UIButton.init(type: .custom)
        pButton.setTitle("开始", for: .normal)
        pButton.setTitle("停止", for: .selected)
        pButton.setTitleColor(UIColor.white, for: .normal)
        pButton.sizeToFit()
        return pButton
    }()
    
    lazy var cancelButton:UIButton = {
        let cButton = UIButton.init(type: .custom)
        cButton.frame = CGRect(x: 20, y: 30, width: 30, height: 30)
        cButton.setImage(LoadImage("closeIcon"), for: .normal)
        cButton.setTitleColor(UIColor.white, for: .normal)
        cButton.sizeToFit()
        
        return cButton
    }()
    
    lazy var typeButton:UIButton = {
        let tButton = UIButton.init(type: .custom)
        tButton.ld_size = CGSize(width: 36, height: 36)
        tButton.layer.cornerRadius = 18
        tButton.clipsToBounds = true
        tButton.setTitleColor(UIColor.white, for: .normal)
        
        return tButton
    }()
    
    lazy var switchCameraButton:UIButton = {
        let sButton = UIButton.init(type: .custom)
        sButton.setImage(LoadImage("capture_shoot_convert"), for: .normal)
        sButton.frame = CGRect(x: KWidth-50, y: 30, width: 30, height: 30)
        sButton.setTitleColor(UIColor.white, for: .normal)
        sButton.sizeToFit()
        return sButton
    }()
    
    lazy var lightButton:UIButton = {
        let lButton = UIButton.init(type: .custom)
        lButton.setImage(LoadImage("capture_shoot_convert"), for: .normal)
        lButton.frame = CGRect(x: KWidth/2-15, y: 30, width: 30, height: 30)
        lButton.sizeToFit()
        return lButton
    }()
    
    

    
    lazy var beautyButton:UIButton = {
        let bButton = UIButton.init(type: .custom)
        bButton.setTitle("美颜", for: .normal)
        bButton.setTitleColor(UIColor.white, for: .normal)
        bButton.sizeToFit()
        return bButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        type = 1
        self.setupUI()
    }
    
    func setupUI() {
        
        self.addSubview(previewView)
        self.addSubview(topView)
        self.addSubview(bottomView)
        
        previewView.addSubview(focusView)
        previewView.addSubview(exposureView)
        
        
        let pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action:#selector(LPYCameraView.pinchAction(Pinch:)) )
        previewView .addGestureRecognizer(pinch)
        
        
        photoButton.center = CGPoint(x: bottomView.ld_centerX, y: bottomView.ld_height/2)
        bottomView.addSubview(photoButton)
        
        typeButton.center = CGPoint(x: 40, y: bottomView.ld_height/2)
        bottomView.addSubview(typeButton)
        
        photoButton.rx.tap.subscribe(onNext: { [weak self] in
            
            self?.delegate?.takeVideo(b: self!.photoButton)
        }).disposed(by: disposeBag)
        
        typeButton.rx.tap.subscribe(onNext: { [weak self] in
            
            self?.delegate?.getLastPhoto(b: self!.typeButton)
        }).disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.cancelBack()
        }).disposed(by: disposeBag)
        
        lightButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.light()
        }).disposed(by: disposeBag)
        
        switchCameraButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.switchCamera()
        }).disposed(by: disposeBag)
        
        topView.addSubview(cancelButton)
        topView.addSubview(lightButton)
        topView.addSubview(switchCameraButton)
    }
    
    @objc func pinchAction(Pinch pinch:UIPinchGestureRecognizer){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


