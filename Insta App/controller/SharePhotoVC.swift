//
//  SharePhotoVC.swift
//  Insta App
//
//  Created by hosam on 4/25/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class SharePhotoVC: UIViewController {
    
    static let updateFeedNotificationName = NSNotification.Name("updateFeed")
    
    
    var selectedImage:UIImage? {
        didSet{
            self.shareImage.image = selectedImage
        }
    }
    
    
    let shareImage:UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.clipsToBounds = true
        
        return im
    }()
    let shareText:UITextView = {
        let tx = UITextView()
        
        tx.sizeToFit()
        
        tx.isScrollEnabled = true
        return tx
    }()
    
    let mainView:UIView = {
        let im = UIView()
        im.backgroundColor = UIColor.white
        
        return im
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupViews()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: -user methods
    
    func setupViews()  {
        view.addSubview(mainView)
        
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 150))
        
        mainView.addSubview(shareImage)
        mainView.addSubview(shareText)
        shareImage.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: nil,padding: .init(top: 8, left: 8, bottom: 8, right: 0),size: .init(width: 100, height: 0))
        shareText.anchor(top: mainView.topAnchor, leading: shareImage.trailingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8),size: .init(width: 0, height: 0))
    }
    
    
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("Posts").child(imageName)
        guard let image = shareImage.image else { return  }
        if let uploadData = image.jpegData(compressionQuality: 0.5){
            storageRef.putData(uploadData, metadata: nil) { (ref, err) in
                
                if err != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (urls, err) in
                        if err == nil {
                            if  let url = urls?.absoluteString {
                                completion(url)
                            }
                        }}
                    )
                }
            }
        }
    }
    
    //TODO: -handle methods
    
    @objc func handleShare()  {
        uploadMedia { (urls) in
            guard let caption   = self.shareText.text, caption.count > 0 else {return}
            guard let url   = urls else {return}
            guard let img   = self.shareImage.image else {return}
            guard let uids = Auth.auth().currentUser?.uid else {return}
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            let values:[String : Any] = ["image-url":url,"caption": caption, "imageWidth": img.size.width, "imageHeight": img.size.height,"creationDate": Date().timeIntervalSince1970]
            
            Database.database().reference(withPath: "Posts").child(uids).childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err == nil {
                    print("successed")
                    
                }else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                //make notification to listen the operation of dismiss
                NotificationCenter.default.post(name: SharePhotoVC.updateFeedNotificationName, object: nil)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
