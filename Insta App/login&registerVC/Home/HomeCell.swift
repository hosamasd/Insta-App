//
//  HomeCell.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    var posts:PostModel? {
        didSet{
            guard let post = posts else { return  }
      self.mainImage.loadImageUsingCacheWithUrlString(post.imageUrl)
        }
    }
    
    let mainImage:UIImageView = {
        let im = UIImageView()
     
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    let profileImage:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .red
        im.layer.cornerRadius = 20
        im.clipsToBounds = true
        return im
    }()
    let userNameLabel:UILabel = {
        let la = UILabel()
        la.textAlignment = .left
        la.text = "hosam elmalt"
        la.font = UIFont.systemFont(ofSize: 16)
        
        return la
    }()
    lazy var optionsButton:UIButton = {
        let bt  = UIButton()
        bt.setTitle("•••", for: .normal)
        bt.setTitleColor(.black, for: .normal)
                bt.addTarget(self, action: #selector(handleMoreOption), for: .touchUpInside)
        
        return bt
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray
       
    
        setupViews()
    }
    
    func setupViews(){
         addSubview(profileImage)
        addSubview(userNameLabel)
        addSubview(optionsButton)
        addSubview(mainImage)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 8, bottom: 0, right: 0),size: .init(width: 40, height: 40))
        userNameLabel.anchor(top: topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 8, bottom: 0, right: 0),size: .init(width: 0, height: 40))
        optionsButton.anchor(top: topAnchor, leading: userNameLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 40))
        mainImage.anchor(top: profileImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        mainImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
   @objc func handleMoreOption()  {
        print(123)
    }
}
