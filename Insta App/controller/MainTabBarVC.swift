//
//  MainTabBarVC.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if login or not
        if !isLogin {
            checkLoginState()
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfile = UserProfileVC(collectionViewLayout: layout)
       let navController = UINavigationController(rootViewController: userProfile)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        viewControllers = [navController,UIViewController()]
        
        
    }
    
    func checkLoginState()  {
        DispatchQueue.main.async {
            let login = LoginVC()
            let nav = UINavigationController(rootViewController: login)
            self.present(nav, animated: true, completion: nil)
        }
        
        
    }
}
