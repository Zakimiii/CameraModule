//
//  ViewController.swift
//  CameraModuleProject
//
//  Created by Apple on 2018/06/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import CameraModule
import AVFoundation
import Foundation

class ViewController: UIViewController, CameraModulePhotoCaptureDelegate {
    
    @IBOutlet weak var button: UIButton!
    let cameraModule = CameraModule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.addTarget( self, action: #selector(self.clickButton), for: .touchUpInside)
        self.cameraModule.viewToDraw = self.view
        self.cameraModule.viewToCaptureVideo = self.view
        cameraModule.CameraModuleDelegate = self
        cameraModule.setupDrawCaptureVideo()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clickButton(){
        self.cameraModule.takePhoto()
    }
    
    func DrawPhotoCapture(_ data: Data, _ viewToDraw: UIView) {
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image)
        imageView.frame = viewToDraw.frame
        viewToDraw.addSubview(imageView)
    }
}

