//
//  UserProfileVC.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let homeCellId = "homeCellId"
    fileprivate let headerId = "headerId"
    var isGridView:Bool = true
    
    var userUids:String?
    
    var user: UserModel?
    var posts: [PostModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        
      // fetchPosts()
      //  fetchOrderdPostes()
    }
     //MARK: -collectionView data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
            let post = posts[indexPath.item]
            
            cell.posts = post
            
            return cell
            
        }else {
            let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath) as! HomeCell
           homeCell.posts = posts[indexPath.item]
            return homeCell
            
        }
     }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            headerId, for: indexPath) as! UserProfileHeaderCell
        header.delgate = self
        header.users = user
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            let width = (view.frame.width - 4 ) / 3
            
            return CGSize(width: width, height: width)
            
        }else {
            var height = view.frame.width + 40 + 16
            height += 50 // for action buttons
            height += 90 // for caption posts
            return .init(width: view.frame.width, height: height)
        }
      
    }
    
   
    //MARK: -user methods
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: homeCellId)
        collectionView.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func fetchUser()  {
         let uids = userUids ??  (Auth.auth().currentUser?.uid ?? "")
        
        Database.database().loadUserInfo(uid: uids) { (user) in
            self.user = user
            self.navigationItem.title =  user.username
            self.fetchOrderdPostes()
        }
        
        
    }
    
    func fetchPosts()  {
        guard  let uids = Auth.auth().currentUser?.uid  else {return}
        Database.database().reference(withPath: "Posts").child(uids).observeSingleEvent(of: .value) { (sanpshot) in
            guard let dictionaries = sanpshot.value as?[String:Any] else {return}
            
            dictionaries.forEach({ (key,value) in
               
                guard let dict = value as?[String:Any] else {return}
                 guard let user = self.user  else {return}
                let post = PostModel(user: user, dict: dict)
                self.posts.append(post)
            })
            
            self.collectionView.reloadData()
        }

    }
    
    func fetchOrderdPostes()  {
        posts.removeAll()
        guard let uids = self.user?.uid else {return}
        Database.database().reference(withPath: "Posts").child(uids).queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
           
            guard let dict  = snapshot.value as? [String:Any] else {return}
             guard let user = self.user else {return}
            let post = PostModel(user: user, dict: dict)
            self.posts.append(post)
            
            self.collectionView.reloadData()
        }
    }
    //TODO: -handle methods
    
   @objc func handleLogOut()  {
    let alert = UIAlertController(title: "sign out?", message: "Are you sure do you want to sign out?", preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    let ok  = UIAlertAction(title: "Sign out", style: .destructive) { (tex) in
        do{
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let login = LoginVC()
                let nav = UINavigationController(rootViewController: login)
                self.present(nav, animated: true, completion: nil)
            }
            print("sign out process")
        }catch let err {
            print(err.localizedDescription)
        }
        
    }
    alert.addAction(ok)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
    }
    
    
    
}

extension UserProfileVC:UserProfileHeaderCellProtocol{
    func changeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
    
    func changeToGridView() {
        isGridView = true
        collectionView.reloadData()
    }
    
    
    
}
