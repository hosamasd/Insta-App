//
//  ViewController.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterVC: UIViewController {

    lazy var plusPhotoButton:UIImageView = {
        let bt  = UIImageView()
    bt.isUserInteractionEnabled = true
        bt.image = #imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal)
        bt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto)))
       
       
        return bt
    }()
    let emailTextField:UITextField = {
       let tf = UITextField()
        tf.placeholder = "Email"
         tf.text = "h@h.com"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
     tf.borderStyle = .roundedRect
         tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let userNameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "User Name"
         tf.text = "hosam"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
         tf.borderStyle = .roundedRect
         tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.text = "123456"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    lazy var signUpButton:UIButton = {
        let bt  = UIButton()
        bt.isEnabled = false
        bt.setTitle("Sign up", for: .normal)
        bt.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
       bt.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        bt.layer.cornerRadius = 5
        bt.setTitleColor(.white, for: .normal)
        return bt
    }()
    lazy var loginButton:UIButton = {
        let bt  = UIButton()
        let attributText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),.foregroundColor: #colorLiteral(red: 0.7707037926, green: 0.7641286254, blue: 0.7707894444, alpha: 1)])
        attributText.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),.foregroundColor: #colorLiteral(red: 0.3835136294, green: 0.6766796708, blue: 0.7637476325, alpha: 1)]))
        bt.setAttributedTitle(attributText, for: .normal)
        bt.addTarget(self, action: #selector(handleLoginPage), for: .touchUpInside)
        bt.setTitleColor(.black, for: .normal)
        return bt
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Register"
        setupViews()
    }


    func setupViews()  {
        let stacks = getStacks(view: emailTextField,userNameTextField,passwordTextField, axis: .vertical)
       
        view.backgroundColor = .white
       view.addSubview(plusPhotoButton)
        view.addSubview(stacks)
       view.addSubview(signUpButton)
        view.addSubview(loginButton)
        
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 60, left: 0, bottom: 0, right: 0),size: .init(width: 140, height: 140))
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stacks.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 50, left: 40, bottom: 0, right: 40),size: .init(width: 0, height: 200))
        signUpButton.anchor(top: stacks.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 20, left: 40, bottom: 0, right: 40),size: .init(width: 0, height: 50))
        loginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor ,trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 8, right: 32),size: .init(width: 0, height: 30))
    }
    
    func getStacks(view: UIView...,axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stacks = UIStackView(arrangedSubviews: view)
        stacks.distribution = .fillEqually
        stacks.axis = axis
        stacks.spacing = 10
        return stacks
    }
    
  @objc  func handleChangePhoto()  {
    let imagePickers = UIImagePickerController()
    imagePickers.delegate = self
    imagePickers.allowsEditing = true
    
    present(imagePickers, animated: true, completion: nil)
    }
    
    @objc  func handleSignUp()  {
       guard let email = emailTextField.text,
        let userName = userNameTextField.text,
        let password = passwordTextField.text
       else { return  }
        
        Auth.auth().createUser(withEmail: email, password: password) { (users, err) in
            
            if  err == nil{
                //something success happning
                
               
                let uploadImage = self.uploadMedia(completion: { (urls) in
                     guard let url = urls else{return}
                    guard let uids = users?.user.uid else{return}
                    
                    let usernameVale = ["username": userName,"image-url":url]
                    let values = [uids: usernameVale]
                    
                    Database.database().reference(withPath: "Users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err == nil {
                            print("successed")
                        }else {
                            print(err?.localizedDescription)
                        }
                    })

                })
            }else{
                 print("failed: ",err )
               
            }
        }
        
    }
    
    @objc func handleLoginPage(){
       navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(r: 17, g: 154, b: 237)
        }else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        }
    }
}

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editied = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.image = editied.withRenderingMode(.alwaysOriginal)
        }else if let original = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.image = original.withRenderingMode(.alwaysOriginal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile-images").child(imageName)
    
        if let uploadData = self.plusPhotoButton.image!.jpegData(compressionQuality: 0.5){
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
    
}