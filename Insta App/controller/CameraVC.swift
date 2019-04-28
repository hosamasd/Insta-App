//
//  CameraVC.swift
//  Insta App
//
//  Created by hosam on 4/28/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import AVFoundation
class CameraVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       setupCaptureSession()
    }
    

    func setupCaptureSession()  {
        let captureSession = AVCaptureSession()
        
        //setup input
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
       
         //setup output
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
         //setup output previews
    }
    

}
