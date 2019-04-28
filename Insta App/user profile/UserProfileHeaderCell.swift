//
//  UserProfileHeaderCell.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol UserProfileHeaderCellProtocol {
    func changeToListView()
    func changeToGridView()
}

class UserProfileHeaderCell: BaseCell {
    
    var delgate:UserProfileHeaderCellProtocol?
    
    let profileImage:UIImageView = {
       let im = UIImageView()
        im.layer.cornerRadius = 80/2
        im.clipsToBounds = true
        return im
    }()
    let userNameLabel:UILabel = {
       let la = UILabel()
        la.textAlignment = .center
        la.font = UIFont.systemFont(ofSize: 16)
       
         return la
    }()
    let postLabel:UILabel = {
        let la = UILabel()
        let attributeText = NSMutableAttributedString(string: "11\n", attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributeText.append(NSAttributedString(string: "post", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        la.attributedText = attributeText
        la.numberOfLines = 0
        la.textAlignment = .center
        la.font = UIFont.systemFont(ofSize: 16)
        return la
    }()
    let followersLabel:UILabel = {
        let la = UILabel()
        let attributeText = NSMutableAttributedString(string: "0\n", attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributeText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        la.attributedText = attributeText
         la.numberOfLines = 0
        la.textAlignment = .center
        la.font = UIFont.systemFont(ofSize: 16)
      
        return la
    }()
    let followeringLabel:UILabel = {
        let la = UILabel()
        let attributeText = NSMutableAttributedString(string: "0\n", attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributeText.append(NSAttributedString(string: "followering", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        la.attributedText = attributeText
         la.numberOfLines = 0
        la.textAlignment = .center
        la.font = UIFont.systemFont(ofSize: 16)
        return la
    }()
    let topView:UIView = {
       let tv = UIView()
        tv.backgroundColor = .lightGray
        
        return tv
    }()
    let bottomView:UIView = {
        let tv = UIView()
        tv.backgroundColor = .lightGray
        
        return tv
    }()
    lazy var editProfileFollowButton:UIButton = {
        let bt  = UIButton()
        bt.setTitle("Edit Profile", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.backgroundColor = .white
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.black.cgColor
        bt.layer.cornerRadius = 6
                bt.addTarget(self, action: #selector(handleChangeText), for: .touchUpInside)
       
        return bt
    }()
    lazy var gridButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        bt.addTarget(self, action: #selector(handleGridView), for: .touchUpInside)
        
        return bt
    }()
    lazy var listButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "list"), for: .normal)
               bt.addTarget(self, action: #selector(handleListView), for: .touchUpInside)
        return bt
    }()
    lazy var bookmarkButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        //        bt.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
         bt.tintColor = UIColor(white: 0, alpha: 0.2)
        return bt
    }()
    
    var users:UserModel? {
        didSet{
            guard let user = users else { return }
            profileImage.loadImageUsingCacheWithUrlString(user.imageUrl)
            userNameLabel.text = user.username
            changeButtonName()
        }
    }
    
   
    
    override func setupViews()  {
        super.setupViews()
        let stackButtons = getStacks(view: gridButton,listButton,bookmarkButton)
        let stackLabels = getStacks(view: postLabel,followersLabel,followeringLabel)
        
        
        addSubview(profileImage)
        addSubview(userNameLabel)
        addSubview(stackLabels)
        addSubview(editProfileFollowButton)
        addSubview(topView)
        addSubview(stackButtons)
        addSubview(bottomView)
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 12, left: 12, bottom: 0, right: 0),size: .init(width: 80, height: 80))
        userNameLabel.anchor(top: profileImage.bottomAnchor, leading: profileImage.leadingAnchor, bottom: nil, trailing: profileImage.trailingAnchor,padding: .init(top: 12, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0))
         stackLabels.anchor(top: topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 12, left: 12, bottom: 0, right: 12),size: .init(width: 0, height: 40))
        editProfileFollowButton.anchor(top: stackLabels.bottomAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 12, left: 12, bottom: 0, right: 12),size: .init(width: 0, height: 30))
         topView.anchor(top: userNameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 18, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 1))
        stackButtons.anchor(top: topView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 12, left: 12, bottom: 0, right: 12),size: .init(width: 0, height: 0))
         bottomView.anchor(top: stackButtons.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 18, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0))
    }
  
   
    
    func getStacks(view: UIView...) -> UIStackView {
        let stacks = UIStackView(arrangedSubviews: view)
        stacks.distribution = .fillEqually
        stacks.axis = .horizontal
        stacks.spacing = 10
        return stacks
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor(r: 17, g: 154, b: 237)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    func changeButtonName()  {
        guard let currentUids = Auth.auth().currentUser?.uid else { return  }
        guard let uidUser = users?.uid else { return  }
        
        if currentUids == uidUser {
            
        }else {
            
            Database.database().reference(withPath: "Following").child(currentUids).child(uidUser).observeSingleEvent(of: .value) { (snapshot) in
                if let isFollow = snapshot.value as? Int, isFollow == 1{
                    self.editProfileFollowButton.setTitle("UnFollow", for: .normal)
                }else {
                    self.setupFollowStyle()
                }
            }
            
            
        }
    }
    fileprivate func setupUnFollowStyle() {
        self.editProfileFollowButton.setTitle("UnFollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func handleChangeText(sender: UIButton)  {
       guard let currentUserUid = Auth.auth().currentUser?.uid else { return  }
    guard let targetUserUid = users?.uid else { return  }
    
        if sender.titleLabel?.text == "UnFollow" {
            //unfollow
            Database.database().reference(withPath: "Following").child(currentUserUid).child(targetUserUid).removeValue { (err, ref) in
                if err == nil {
                    print("removed following successfully")
                }
                self.setupFollowStyle()
            }
        }else   {
    let values = [targetUserUid:1]
    Database.database().reference(withPath: "Following").child(currentUserUid).updateChildValues(values) { (err, ref) in
        if err == nil {
            print("successed!")
        }
        self.setupUnFollowStyle()
    }
        }
    }
    
    @objc func handleListView(){
       delgate?.changeToListView()
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    
    @objc func handleGridView(){
       delgate?.changeToGridView()
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
}
