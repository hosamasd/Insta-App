//
//  MainTabBarVC.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
    var isLogin = true
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if login or not
        if !isLogin {
            checkLoginState()
        }
        
        setupViewControllers()
        
        
    }
    
    //MARK: -USER METHODS
    
    fileprivate func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let userProfile = UserProfileVC(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfile)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        viewControllers = [navController,UIViewController()]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    func checkLoginState()  {
        DispatchQueue.main.async {
            let login = LoginVC()
            let nav = UINavigationController(rootViewController: login)
            self.present(nav, animated: true, completion: nil)
        }
        
        
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
