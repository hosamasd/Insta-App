//
//  LoginVC.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    let mainView:UIView = {
        let mv = UIView()
        mv.backgroundColor = UIColor(r: 0, g: 120, b: 175)
        return mv
    }()
    
    let  mainImageLogo:UIImageView = {
        let bt  = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        bt.contentMode = .scaleAspectFill
        return bt
    }()
    lazy var signUpButton:UIButton = {
        let bt  = UIButton()
        let attributText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),.foregroundColor: #colorLiteral(red: 0.7707037926, green: 0.7641286254, blue: 0.7707894444, alpha: 1)])
        attributText.append(NSAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),.foregroundColor: #colorLiteral(red: 0.3835136294, green: 0.6766796708, blue: 0.7637476325, alpha: 1)]))
        bt.setAttributedTitle(attributText, for: .normal)
        bt.addTarget(self, action: #selector(handleSignUpPage), for: .touchUpInside)
        bt.setTitleColor(.black, for: .normal)
        return bt
    }()
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    lazy var loginButton:UIButton = {
        let bt  = UIButton()
        bt.isEnabled = false
        bt.setTitle("Login", for: .normal)
        bt.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        bt.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        bt.layer.cornerRadius = 5
        bt.setTitleColor(.white, for: .normal)
        return bt
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getStacks(view: UIView...,axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stacks = UIStackView(arrangedSubviews: view)
        stacks.distribution = .fillEqually
        stacks.axis = axis
        stacks.spacing = 10
        return stacks
    }
    
    func setupViews()  {
        let stacks = getStacks(view: emailTextField,passwordTextField, axis: .vertical)
        
        addViews(mainView,signUpButton,stacks,loginButton)
        mainView.addSubview(mainImageLogo)
        
        mainView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 150))
        mainImageLogo.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,size: .init(width: 200, height: 50))
        mainImageLogo.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        mainImageLogo.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        
        stacks.anchor(top: mainView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 50, left: 40, bottom: 0, right: 40),size: .init(width: 0, height: 120))
        loginButton.anchor(top: stacks.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 20, left: 40, bottom: 0, right: 40),size: .init(width: 0, height: 50))
        signUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor ,trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 8, right: 32),size: .init(width: 0, height: 30))
        
    }
    
    //MARK: - user methods
    
    func addViews(_ views: UIView...)  {
        view.backgroundColor = .white
        views.forEach({view.addSubview($0)})
    }
    
    func createAlert(title:String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //TODO: -handle methods
    
    @objc func handleSignUpPage()  {
        let register = RegisterVC()
        navigationController?.pushViewController(register, animated: true)
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else { return  }
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if  err == nil{
                
                self.dismiss(animated: true, completion: nil)
            }else {
                self.createAlert(title: "Error happened!", message: "there is an problem \n \(err?.localizedDescription)")
            }
        }
    }
    
    @objc func handleTextChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.mainBlue()
        }else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        }
    }
}
