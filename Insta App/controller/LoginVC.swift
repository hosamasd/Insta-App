//
//  LoginVC.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    let  mainImageLogo:UIImageView = {
        let bt  = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        bt.contentMode = .scaleAspectFit
       bt.backgroundColor = #colorLiteral(red: 0.149969697, green: 0.5567626357, blue: 0.6988043189, alpha: 1)
       
        return bt
    }()
    lazy var signUpButton:UIButton = {
        let bt  = UIButton()
        bt.setTitle("don't have an account? sign up", for: .normal)
        bt.addTarget(self, action: #selector(handleSignUpPage), for: .touchUpInside)
        bt.setTitleColor(.black, for: .normal)
        return bt
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupViews()
    }
    
    func setupViews()  {
        view.addSubview(mainImageLogo)
        view.addSubview(signUpButton)
        
        
        mainImageLogo.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 250))
        signUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor ,trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 8, right: 32),size: .init(width: 0, height: 30))
    }
    
    //TODO: -handle methods
    
   @objc func handleSignUpPage()  {
        let register = RegisterVC()
        navigationController?.pushViewController(register, animated: true)
    }
}
