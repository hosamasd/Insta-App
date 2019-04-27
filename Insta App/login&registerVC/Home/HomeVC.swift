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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImage.tintColor = UIColor.black
        navigationItem.titleView = logoImage
        
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchOrderdPostes()
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
        let height = view.frame.width + 40 + 16 + 50
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func fetchOrderdPostes()  {
        posts.removeAll()
        guard let uids = Auth.auth().currentUser?.uid else {return}
        Database.database().reference(withPath: "Posts").child(uids).queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            
            guard let dict  = snapshot.value as? [String:Any] else {return}
            let post = PostModel(dict: dict)
            self.posts.append(post)
            
            self.collectionView.reloadData()
        }
    }
    
}
