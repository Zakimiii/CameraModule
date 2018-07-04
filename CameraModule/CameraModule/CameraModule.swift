//
//  CameraModule.swift
//  CameraModule
//
//  Created by Apple on 2018/06/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

@available(iOS 11.0, tvOS 11.0, *)
@objc public protocol CameraModulePhotoCaptureDelegate {
    @objc optional func DrawPhotoCapture(_ data: Data, _ viewToDraw: UIView)
}

@available(iOS 11.0, tvOS 11.0, *)
@objcMembers
public class CameraModule: AVCapturePhotoSettings, AVCapturePhotoCaptureDelegate {
    
    public var CameraModuleDelegate: CameraModulePhotoCaptureDelegate!
    public weak var viewToDraw =  UIView()
    public weak var viewToCaptureVideo = UIView()
    public let captureSesssion = AVCaptureSession()
    public let capturePhotoOutput =  AVCapturePhotoOutput()
    
    open func setupDrawCaptureVideo(){
        super.drawCaptureVideo(self.viewToCaptureVideo! , self.captureSesssion, self.capturePhotoOutput)
    }
    
    open func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            CameraModuleDelegate.DrawPhotoCapture?(photoData!, self.viewToDraw!)
        }
    }
    
    open func takePhoto () {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .off
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        capturePhotoOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
}

@available(iOS 11.0, tvOS 11.0, *)
extension AVCapturePhotoSettings {
    
    public func drawCaptureVideo (_ drawView: UIView,_ captureSesssion:  AVCaptureSession,_  capturePhotoOutput: AVCapturePhotoOutput) {
        
        guard let device = AVCaptureDevice.default(for: .video) else {
            return print("can't use camera function in simulator")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(capturePhotoOutput)) {
                    captureSesssion.addOutput(capturePhotoOutput)
                    captureSesssion.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSesssion)
                    captureVideoLayer.frame = drawView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    drawView.layer.insertSublayer(captureVideoLayer, at: 0)
                }
            }
        }
        catch {
            print(error)
        }
    }
}
extension UIView {
    public func GetImage() -> UIImage{
        // キャプチャする範囲を取得.
        let rect = self.bounds
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // contextを閉じる.
        UIGraphicsEndImageContext()
        return capturedImage
    }
}
