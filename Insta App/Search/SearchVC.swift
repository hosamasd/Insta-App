//
//  SearchVC.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    let searchBar:UISearchBar = {
       let se = UISearchBar()
        se.placeholder = "enter user name?"
        return se
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupViews()
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 44)
    }
    
   
    func setupViews()  {
        navigationController?.navigationBar.addSubview(searchBar)
        let nav = navigationController?.navigationBar
        searchBar.anchor(top: nav?.topAnchor, leading: nav?.leadingAnchor, bottom: nav?.bottomAnchor, trailing: nav?.trailingAnchor,padding: .init(top: 0, left: 8, bottom: 0, right: 8))
    }
    
}
