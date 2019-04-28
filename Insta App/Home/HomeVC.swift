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
        
        cell.delgate = self
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
            
            guard let uidsDict = snapshot.value as? [String: Any] else { return  }
            
            uidsDict.forEach({ (key,value) in
                Database.database().loadUserInfo(uid: key, completion: { (user) in
                    self.fetchOrderdPostes(uid: key, user: user,id:key)
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
    
    func fetchOrderdPostes(uid:String,user:UserModel,id:String? = nil)  {
        
        Database.database().reference(withPath: "Posts").child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key,value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = PostModel(user: user, dict: dictionary)
                post.id = key
                self.posts.append(post)
                
                self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.collectionView?.reloadData()
            })
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

extension HomeVC:HomeCellProtocol {
    func didTapPost(post: PostModel) {
        let comment = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        comment.posts = post
        navigationController?.pushViewController(comment, animated: true)
        
    }
    
    
}
