//
//  SearchCell.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class SearchCell: BaseCell {
    
    var users:UserModel? {
        didSet{
            guard let user = users else { return  }
           self.profileImage.loadImageUsingCacheWithUrlString(user.imageUrl)
            self.userNameLabel.text = user.username
        }
    }
    
    let profileImage:UIImageView = {
        let im = UIImageView()
        im.layer.cornerRadius = 20
        im.clipsToBounds = true
        return im
    }()
    let userNameLabel:UILabel = {
        let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 16)
        
        return la
    }()
    let numOfPostsLabel:UILabel = {
        let la = UILabel()
        la.text = "13 posts"
        la.textColor = .lightGray
        la.font = UIFont.systemFont(ofSize: 16)
        
        return la
    }()
    let seperatorView:UIView = {
       let se = UIView()
        se.backgroundColor = .lightGray
        return se
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(userNameLabel)
        addSubview(numOfPostsLabel)
        addSubview(seperatorView)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 8, bottom: 0, right: 0),size: .init(width: 80, height: 80))
        userNameLabel.anchor(top: topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 30))
        numOfPostsLabel.anchor(top: topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 0))
        seperatorView.anchor(top: numOfPostsLabel.bottomAnchor, leading: profileImage.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 0),size: .init(width: 0, height: 1))
    }
   
    
}
