//
//  MainTabBarVC.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if login or not
        self.delegate = self
        checkLoginState()
        
        setupViewControllers()
   }
    
    //MARK: -USER METHODS
    
    fileprivate func setupViewControllers() {
       
        
        let home = templateNavControllerVC(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeVC(collectionViewLayout: UICollectionViewFlowLayout() ))
         let search = templateNavControllerVC(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchVC(collectionViewLayout: UICollectionViewFlowLayout()) )
         let like = templateNavControllerVC(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: LikeVC())
         let plus = templateNavControllerVC(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: PlusVC())
        
         let layout = UICollectionViewFlowLayout()
        let userProfile = UserProfileVC(collectionViewLayout: layout )
        let userProdVC = templateNavControllerVC(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: userProfile)
        
        tabBar.tintColor = .black
        
        viewControllers = [
            home,
            search,
            plus,
            like,
            userProdVC]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
   fileprivate func checkLoginState()  {
    if Auth.auth().currentUser?.uid == nil {
        DispatchQueue.main.async {
            let login = LoginVC()
            let nav = UINavigationController(rootViewController: login)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    }
    
    fileprivate func templateNavControllerVC(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
extension MainTabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            let index = tabBarController.viewControllers?.index(of: viewController)
        if index == 2 {
            let photo = PhotoSelectorVC(collectionViewLayout: UICollectionViewFlowLayout())
            let nav = UINavigationController(rootViewController: photo)
            
           present(nav, animated: true, completion: nil)
            
          return false
        }
        return true
        
    }
}
