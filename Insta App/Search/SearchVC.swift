//
//  SearchVC.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    var users = [UserModel]()
    
    
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
        
        fetchUsers()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        let user = users[indexPath.row]
        
        cell.users = user
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func fetchUsers()  {
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        Database.database().loadUserInfo(uid: uids) { (user) in
            self.users.append(user)
            self.collectionView.reloadData()
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
        print(2222)
    }
}
