//
//  AVFoundationModel.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/27.
//  Copyright © 2018年 aaron. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

protocol AVFoundationModelDelegate: NSObjectProtocol{
    
    func fileOutput(ms:String)
}

class AVFoundationModel: NSObject {
    
    /// 前置摄像头输入
    var frontCamera : AVCaptureDeviceInput?
    /// 后置摄像头输入
    var backCamera : AVCaptureDeviceInput?
    /// 当前视频输入摄像头
    var videoInputDevice : AVCaptureDeviceInput?
    
    weak var delegate:AVFoundationModelDelegate?
    
    var _deviceInput:AVCaptureDeviceInput!
    var videoOutput:AVCaptureVideoDataOutput!
    var imageOutput:AVCaptureStillImageOutput!
    
    //视频输出流
//    @property (strong,nonatomic) AVCaptureMovieFileOutput  *captureMovieFileOutput
    var captureMovieFileOutput:AVCaptureMovieFileOutput = {
        let cap = AVCaptureMovieFileOutput()
        
        return cap
    }()
    
    
    lazy var _session:AVCaptureSession = {
        let session = AVCaptureSession.init()
        return session
    }()
    
    lazy var captureVideoPreviewLayer:AVCaptureVideoPreviewLayer = {
        let pvl = AVCaptureVideoPreviewLayer.init(session: _session)
        
        
        pvl.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        return pvl
    }()
    
    func setDrawUI(view:UIView,cv:UIView) {
        
        self.setupSession(view: view, cv: cv)
        // MARK: 初始化输入设备
        let videoDevices = AVCaptureDevice.devices(for: .video)
        /// 前置摄像头
        let f = videoDevices.filter({ return $0.position == .front }).first
        /// 后置摄像头
        let b = videoDevices.filter({ return $0.position == .back }).first
        frontCamera = try? AVCaptureDeviceInput(device: f!)
        backCamera = try? AVCaptureDeviceInput(device: b!)
        self.startCaptureSrssion()
        
    }
    
    func startCaptureSrssion(){
        
        if !_session.isRunning {
            _session.startRunning()
        }
    }
    
    func stopCaptureSrssion(){
        
        if _session.isRunning {
            _session.stopRunning()
        }
    }
    
    func setupSession(view:UIView,cv:UIView){
        
        _session.sessionPreset = .high
        
        setupSessionInputs()
        setupSessionOutputs(view:view, cv: cv)
        
    }
    
    func setupSessionInputs(){
        
        let videoDevice = AVCaptureDevice.default(for: .video)
        ///设置当前摄像头为前置摄像头
        
        do {
            //初始化媒体捕捉的输入流
            let videoInput = try AVCaptureDeviceInput(device: videoDevice!)
            
            //设置输入到Session
            if _session.canAddInput(videoInput) {
                _session.addInput(videoInput)
            }
            _deviceInput = videoInput;
            videoInputDevice = videoInput
        }
        catch {
            // 捕获异常退出
            print(error)
            return
            
        }
        
        
        let audioDevice = AVCaptureDevice.default(for: .audio)
        do {
            //初始化媒体捕捉的输入流
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            //设置输入到Session
            if _session.canAddInput(audioInput) {
                _session.addInput(audioInput)
            }
        }
        catch {
            // 捕获异常退出
            print(error)
            return
            
        }
    }
    
    func setupSessionOutputs(view:UIView, cv:UIView){
        
        let quece = DispatchQueue(label: "quece")
        
        let videoOut = AVCaptureVideoDataOutput.init()
        videoOut.alwaysDiscardsLateVideoFrames = true
        videoOut.videoSettings = [kCVPixelBufferPixelFormatTypeKey:kCVPixelFormatType_32BGRA] as [String : Any]
        videoOut.setSampleBufferDelegate(self, queue: quece)
        
        if _session.canAddOutput(videoOut) {
            _session.addOutput(videoOut)
        }
        
        //将设备输出添加到会话中
        if _session.canAddOutput(captureMovieFileOutput) {
            _session.addOutput(captureMovieFileOutput)
        }
        
        let audioOut = AVCaptureAudioDataOutput.init()
        audioOut .setSampleBufferDelegate(self, queue: quece)
        if _session.canAddOutput(audioOut) {
            _session.addOutput(audioOut)
        }
        
        let imageOut = AVCaptureStillImageOutput.init()
        imageOut.outputSettings = [AVVideoCodecKey:AVVideoCodecType.jpeg]
        if _session.canAddOutput(imageOut) {
            _session.addOutput(imageOut)
        }
        
        let layer = view.layer
        layer.masksToBounds = true
        captureVideoPreviewLayer.frame = layer.bounds
        layer.insertSublayer(captureVideoPreviewLayer, below: cv.layer)
    }
    
    func cameraWithPosition(Position position:AVCaptureDevice.Position) ->AVCaptureDevice?{
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device:AVCaptureDevice in devices {
            if device.position == position{
                return device;
            }
        }
        return nil;
    }
    
    //录制视频
    func takeClick(b:UIButton){

        if self.captureMovieFileOutput.isRecording {
            self.captureMovieFileOutput.stopRecording()
            b.isSelected = false
        }else {
            b.isSelected = true
            let captureConnection = captureMovieFileOutput.connection(with: .video)
            captureConnection?.videoOrientation = (captureVideoPreviewLayer.connection?.videoOrientation)!
            let filePath = NSTemporaryDirectory().appendingPathComponent("Movie.mov")
            captureMovieFileOutput.startRecording(to: URL.init(fileURLWithPath: filePath), recordingDelegate: self)
        }
    }
    
}

extension AVFoundationModel:AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate{
    
    //输出
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    //开始录制
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    //结束录制
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        var message:String!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                message = "保存成功!"
            } else{
                message = "保存失败：\(error!.localizedDescription)"
            }
            
            DispatchQueue.main.async {
                //弹出提示框
                self.delegate?.fileOutput(ms: message)
                
            }
        })
    }
    
}
