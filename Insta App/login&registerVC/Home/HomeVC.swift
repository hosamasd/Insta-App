//
//  HomeVC.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    var posts = [PostModel]()
    var users:UserModel?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //listen to notifcaastion and do some code
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeds), name: SharePhotoVC.updateFeedNotificationName, object: nil)
        
        setupNavigation()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        
         fetchAllPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        fetchUser()
//
//        fetchFollowingPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        let post = posts[indexPath.item]
        
        cell.posts = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = view.frame.width + 40 + 16
        height += 50 // for action buttons
        height += 90 // for caption posts
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func fetchFollowingPosts()  {
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        Database.database().reference(withPath: "Following").child(uids).observeSingleEvent(of: .value) { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            guard let uidsDict = snapshot.value as? [String: Any] else { return  }

            uidsDict.forEach({ (key,value) in
                Database.database().loadUserInfo(uid: key, completion: { (user) in
                     self.fetchOrderdPostes(uid: key, user: user)
                })
               
            })
        }
    }
    
    func fetchUser()  {
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        
        Database.database().loadUserInfo(uid: uids) { (user) in
            
            self.fetchOrderdPostes(uid: uids, user: user)
        }
        
           
        
        
    }
    
    func fetchOrderdPostes(uid:String,user:UserModel)  {
//        posts.removeAll()
        
         Database.database().reference(withPath: "Posts").child(uid).queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            
            guard let dict  = snapshot.value as? [String:Any] else {return}
            
            let post = PostModel(user: user, dict: dict)
            self.posts.append(post)
            
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func fetchAllPosts() {
        fetchUser()
        fetchFollowingPosts()
    }
    fileprivate func setupNavigation() {
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImage.tintColor = UIColor.black
        navigationItem.titleView = logoImage
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3"), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleRefreshControl()  {
        posts.removeAll()
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeeds(){
        handleRefreshControl()
    }
    
    @objc func handleCamera(){
        let camera = CameraVC()
        present(camera, animated: true, completion: nil)
    }
}
