//
//  CameraVC.swift
//  Insta App
//
//  Created by hosam on 4/28/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import AVFoundation
class CameraVC: UIViewController,UIViewControllerTransitioningDelegate {

    let output = AVCapturePhotoOutput()
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    lazy var captureButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
               bt.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        
        return bt
    }()
    lazy var backButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        bt.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return bt
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self
       setupCaptureSession()
        setupViews()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationDismisser
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    func setupViews()  {
        view.addSubview(captureButton)
        view.addSubview(backButton)
        
        captureButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 30, right: 0),size: .init(width: 80, height: 80))
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 8),size: .init(width: 50, height: 50))
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
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
         //setup output previews
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
   @objc func handleCapturePhoto()  {
    let setting = AVCapturePhotoSettings()
    guard let previewFormatType = setting.availablePreviewPhotoPixelFormatTypes.first else { return  }
    setting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey: previewFormatType] as [String : Any]
    output.capturePhoto(with: setting, delegate: self)
    }

  @objc  func handleBack()  {
        dismiss(animated: true, completion: nil)
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate{
    
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: <#T##CMSampleBuffer#>, previewPhotoSampleBuffer: <#T##CMSampleBuffer?#>)
//
//        let previewImage = UIImage(data: <#T##Data#>)
//
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        let previewImage = UIImage(data: imageData)
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.fillSuperview()
        print("successed")
    }
}
