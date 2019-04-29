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
    var isFinishPagination:Bool = false
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
        if indexPath.item == self.posts.count - 1 && !isFinishPagination{
            paginatePosts()
        }
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
            //            self.fetchOrderdPostes()
            self.paginatePosts()
        }
        
        
    }
    
    func paginatePosts()  {
        self.posts.removeAll()
        guard let uids = self.user?.uid else {return}
        let ref =  Database.database().reference(withPath: "Posts").child(uids)
        
        //        let query = ref.queryOrderedByKey().queryStarting(atValue: value).queryLimited(toFirst: 6)
        var query = ref.queryOrderedByKey()
       query.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
            guard var  allOjects = snapshot.children.allObjects as?[DataSnapshot] else {return}
            
            allOjects.reverse()
            if allOjects.count < 4 {
                self.isFinishPagination = true
            }
            
            if self.posts.count > 0 && allOjects.count > 0{
                self.posts.removeFirst()
            }
            
            guard let user = self.user  else {return}
            allOjects.forEach({ (snap) in
                
                
                guard let dict = snap.value as?[String:Any] else {return}
                
                var post = PostModel(user: user, dict: dict)
                post.id = snap.key
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
            self.posts.insert(post, at: 0)
            
            self.collectionView.reloadData()
        }
    }
    
    func createAlert(title:String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let logOut = UIAlertAction(title: "Sign Out", style: .destructive) { (signOut) in
            do{
                try Auth.auth().signOut()
                
                DispatchQueue.main.async {
                    let login = LoginVC()
                    let nav = UINavigationController(rootViewController: login)
                    self.present(nav, animated: true, completion: nil)
                }
            }catch let err {
                print(err.localizedDescription)
            }
        }
        
        alert.addAction(action)
        alert.addAction(logOut)
        present(alert, animated: true, completion: nil)
        
    }
    
    //TODO: -handle methods
    
    @objc func handleLogOut()  {
    
        createAlert(title: "Sign Out", message: "Are you sure do you want to sign out?")
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
