//
//  AddVideoViewController.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/26.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import Photos

class AddVideoViewController: UIViewController {
    
    private var disposeBag = DisposeBag()

    lazy var cameraView:LPYCameraView = {
        let cview = LPYCameraView.init(frame: self.view.bounds);
        cview.delegate = self
        return cview
    }()
    
    lazy var model:AVFoundationModel = {
        let av = AVFoundationModel()
        av.delegate = self
        return av
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cameraView)
        
        
        model.setDrawUI(view: self.view, cv: self.cameraView)
        
        CaptureModel.getPreLastImage(b: cameraView.typeButton)

        getAll()
    }
    
    func getAll() -> Void {
        
        model.stopCaptureSrssion()
        
        let addVideoVc = LPYViewController.init(frame: self.view.bounds)
        addVideoVc.model = model
        self.view.addSubview(addVideoVc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("deinit")
    }
}

extension AddVideoViewController: LPYCameraViewDelegate,AVFoundationModelDelegate {
    
    //视频输出
    func fileOutput(ms:String) {
        
        let alertController = UIAlertController(title: ms, message: nil,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //摄像
    func takeVideo(b: UIButton) {
        
        model.takeClick(b: b)
    }
    
    //LPYCameraViewDelegate
    func switchCamera() {
        //切换摄像头
        model._session.beginConfiguration()
        let currenInput = (model.videoInputDevice == model.frontCamera ? model.backCamera : model.frontCamera)
        model._session.removeInput(model.videoInputDevice!)
        model._session.addInput(currenInput!)
        model._session.commitConfiguration()
        model.videoInputDevice = currenInput
        
    }
    
    func light() {
        
        //开关闪光灯
        let isLightOpened = CaptureModel.isLightOpened()
        CaptureModel.openLight(open: !isLightOpened)
        
    }
    
    func getLastPhoto(b button: UIButton) {
        
        
        getAll()
    }
    
    
    func cancelBack() {
        //关闭
        dismiss(animated: true, completion: nil)
    }
    
}

