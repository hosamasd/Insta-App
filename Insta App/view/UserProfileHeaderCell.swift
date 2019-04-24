//
//  UserProfileHeaderCell.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class UserProfileHeaderCell: UICollectionReusableView {
    let profileImage:UIImageView = {
       let im = UIImageView()
        im.backgroundColor = .red
        im.layer.cornerRadius = 80/2
        im.clipsToBounds = true
        return im
    }()
    let userNameLabel:UILabel = {
       let la = UILabel()
        la.text = "user name"
        la.font = UIFont.systemFont(ofSize: 16)
        la.backgroundColor = .red
        return la
    }()
    let postLabel:UILabel = {
        let la = UILabel()
        la.text = "11\nPost"
        la.numberOfLines = 0
        la.textAlignment = .center
        la.font = UIFont.systemFont(ofSize: 16)
        return la
    }()
    let followersLabel:UILabel = {
        let la = UILabel()
        la.text = "11\nFollowers"
         la.numberOfLines = 0
        la.textAlignment = .center
        la.font = UIFont.systemFont(ofSize: 16)
      
        return la
    }()
    let followeringLabel:UILabel = {
        let la = UILabel()
        la.text = "11\nFollowering"
         la.numberOfLines = 0
        la.textAlignment = .center
        la.font = UIFont.systemFont(ofSize: 16)
        return la
    }()
    lazy var editProfileButton:UIButton = {
        let bt  = UIButton()
        bt.setTitle("Edit Profile", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.backgroundColor = .white
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.black.cgColor
        bt.layer.cornerRadius = 6
        //        bt.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
       
        return bt
    }()
    lazy var gridButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
//        bt.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        
        return bt
    }()
    lazy var listButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        //        bt.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        bt.tintColor = UIColor(white: 0, alpha: 0.2)
        return bt
    }()
    lazy var bookmarkButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        //        bt.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
         bt.tintColor = UIColor(white: 0, alpha: 0.2)
        return bt
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
       
        setupViews()
    }
    
    func setupViews()  {
        let stackButtons = getStacks(view: gridButton,listButton,bookmarkButton)
        let stackLabels = getStacks(view: postLabel,followersLabel,followeringLabel)
        
        
        addSubview(profileImage)
        addSubview(userNameLabel)
        addSubview(stackLabels)
        addSubview(editProfileButton)
        addSubview(stackButtons)
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 12, left: 12, bottom: 0, right: 0),size: .init(width: 80, height: 80))
        userNameLabel.anchor(top: profileImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 12, left: 12, bottom: 0, right: 0),size: .init(width: 0, height: 0))
         stackLabels.anchor(top: topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 12, left: 12, bottom: 0, right: 12),size: .init(width: 0, height: 40))
        editProfileButton.anchor(top: stackLabels.bottomAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 12, left: 12, bottom: 0, right: 12),size: .init(width: 0, height: 30))
        stackButtons.anchor(top: profileImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 80, left: 12, bottom: 0, right: 12),size: .init(width: 0, height: 00))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStacks(view: UIView...) -> UIStackView {
        let stacks = UIStackView(arrangedSubviews: view)
        stacks.distribution = .fillEqually
        stacks.axis = .horizontal
        stacks.spacing = 10
        return stacks
    }
}
