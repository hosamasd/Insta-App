//
//  SearchVC.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    var users = [UserModel]()
    var filterUsers = [UserModel]()
    
    lazy var searchBar:UISearchBar = {
       let se = UISearchBar()
        se.placeholder = "enter user name?"
        se.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(r: 240, g: 240, b: 240)
        se.delegate = self
        return se
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupViews()
        collectionView.backgroundColor = .white
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.resignFirstResponder()
        searchBar.isHidden = false
//        fetchUsers()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        let user = filterUsers[indexPath.row]
        
        cell.users = user
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let userProf =  UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout() )
        userProf.userUids = users[indexPath.item].uid
        navigationController?.pushViewController(userProf, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func fetchUsers()  {
//    self.users.removeAll()
//        self.filterUsers.removeAll()
        
        Database.database().reference(withPath: "Users").observe(.childAdded) { (snapshot) in
           guard let dictionary = snapshot.key as? String else {return}
           
                Database.database().loadUserInfo(uid: dictionary, completion: { (user) in
                   self.users.append(user)
                    
                    self.users.sort(by: { (u1, u2) -> Bool in
                        return u1.username.compare(u2.username) == .orderedAscending
                 
                })
                    self.filterUsers = self.users
          self.collectionView.reloadData()
            })
            
            
            }
        
       
        
    }
    func setupViews()  {
        navigationController?.navigationBar.addSubview(searchBar)
        let nav = navigationController?.navigationBar
        searchBar.anchor(top: nav?.topAnchor, leading: nav?.leadingAnchor, bottom: nav?.bottomAnchor, trailing: nav?.trailingAnchor,padding: .init(top: 0, left: 8, bottom: 0, right: 8))
    }
    
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterUsers = users
        }else {
        self.filterUsers = users.filter({ (user) -> Bool in
             user.username.lowercased().contains(searchText.lowercased())
        })
       
    }
         self.collectionView.reloadData()
    }
}
