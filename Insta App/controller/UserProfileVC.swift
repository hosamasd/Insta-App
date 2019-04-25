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
    fileprivate let headerId = "headerId"
    
    var user: UserModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        setupCollectionView()
        fetchUser()
    }
    
     //MARK: -collectionView data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
        
        return cell
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
        header.users = user
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4 ) / 3
        
        return CGSize(width: width, height: width)
       
    }
    
   
    //MARK: -user methods
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func fetchUser()  {
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        
        Database.database().reference(withPath: "Users").child(uids).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String:Any]else {return}
            self.user = UserModel(dict: dict)
          self.navigationItem.title =  dict["username"] as? String ?? "no name"
            self.collectionView.reloadData()
        }
    }
    
    //TODO: -handle methods
    
   @objc func handleLogOut()  {
    let alert = UIAlertController(title: "sign out?", message: "Are you sure do you want to sign out?", preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    let ok  = UIAlertAction(title: "OK", style: .destructive) { (tex) in
        print("sign out process")
    }
    alert.addAction(ok)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
    }
    
    
    
}
