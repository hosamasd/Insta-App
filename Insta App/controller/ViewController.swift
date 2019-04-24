//
//  ViewController.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var plusPhotoButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    let emailTextField:UITextField = {
       let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
     tf.borderStyle = .roundedRect
        return tf
    }()
    let userNameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "User Name"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
         tf.borderStyle = .roundedRect
        return tf
    }()
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        return tf
    }()
    lazy var signUpButton:UIButton = {
        let bt  = UIButton()
        bt.setTitle("Sign up", for: .normal)
        bt.addTarget(self, action: #selector(handleSugnUp), for: .touchUpInside)
       bt.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        bt.layer.cornerRadius = 5
        bt.setTitleColor(.white, for: .normal)
        return bt
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
    }


    func setupViews()  {
        let stacks = UIStackView(arrangedSubviews: [emailTextField,userNameTextField,passwordTextField])
        stacks.spacing = 10
        stacks.axis = .vertical
        stacks.distribution = .fillEqually
        
        view.backgroundColor = .white
       view.addSubview(plusPhotoButton)
        view.addSubview(stacks)
       view.addSubview(signUpButton)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        stacks.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 50, left: 40, bottom: 0, right: 40),size: .init(width: 0, height: 200))
        signUpButton.anchor(top: stacks.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 20, left: 40, bottom: 0, right: 40),size: .init(width: 0, height: 50))
        
    }
    
  @objc  func handleChangePhoto()  {
        print(123)
    }
    
    @objc  func handleSugnUp()  {
        print(000)
    }
}

