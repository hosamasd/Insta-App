//
//  HomeCell.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

protocol HomeCellProtocol {
    func didTapPost(post:PostModel)
    func didLike(for cell:HomeCell)
}

class HomeCell: UICollectionViewCell {
    var delgate:HomeCellProtocol?
    
    var posts:PostModel? {
        didSet{
            guard let post = posts else { return  }
      self.mainImage.loadImageUsingCacheWithUrlString(post.imageUrl)
            self.userNameLabel.text = post.user.username
            self.profileImage.loadImageUsingCacheWithUrlString(post.user.imageUrl)
            let selected = post.hasLiked ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal)
            self.likeButton.setImage(selected, for: .normal)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let stringDate =   post.creationDate.getElapsedInterval(dates: post.creationDate)
            
            let attributeText = NSMutableAttributedString(string: "\(post.user.username): ", attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributeText.append(NSAttributedString(string: "\(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            attributeText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
            attributeText.append(NSAttributedString(string: stringDate, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
            
            
            
            self.captionLabel.attributedText = attributeText
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
        im.layer.cornerRadius = 20
        im.clipsToBounds = true
        return im
    }()
    let userNameLabel:UILabel = {
        let la = UILabel()
        la.textAlignment = .left
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
    lazy var likeButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        bt.tintColor = UIColor.blue
               bt.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        return bt
    }()
    lazy var commentButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
              bt.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        bt.tintColor = UIColor(white: 0, alpha: 0.2)
        return bt
    }()
    lazy var sendMessageButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
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
    let captionLabel:UILabel = {
        let la = UILabel()
       
        
        la.numberOfLines = 0
        la.font = UIFont.systemFont(ofSize: 16)
        
        return la
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
       
    
        setupViews()
    }
    
    func setupViews(){
        let stacks = getStacks(view: likeButton,commentButton,sendMessageButton)
        
        addViews(profileImage,userNameLabel,optionsButton,mainImage,stacks,bookmarkButton,captionLabel)
        
//         addSubview(profileImage)
//        addSubview(userNameLabel)
//        addSubview(optionsButton)
//        addSubview(mainImage)
//        addSubview(stacks)
//        addSubview(bookmarkButton)
//        addSubview(captionLabel)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 8, bottom: 0, right: 0),size: .init(width: 40, height: 40))
        userNameLabel.anchor(top: topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 8, bottom: 0, right: 0),size: .init(width: 0, height: 40))
        optionsButton.anchor(top: topAnchor, leading: userNameLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 40))
        mainImage.anchor(top: profileImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        mainImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        stacks.anchor(top: mainImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 16, bottom: 0, right: 0),size: .init(width: 105, height: 42))
        bookmarkButton.anchor(top: mainImage.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 16),size: .init(width: 42, height: 42))
        captionLabel.anchor(top: bookmarkButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - user methods
    
    func addViews(_ views: UIView...)  {
        views.forEach({addSubview($0)})
    }
    
    func getStacks(view: UIView...) -> UIStackView {
        let stacks = UIStackView(arrangedSubviews: view)
        stacks.distribution = .fillEqually
        stacks.axis = .horizontal
        stacks.spacing = 5
        return stacks
    }
   
   @objc func handleMoreOption()  {
        print(123)
    }
    
  @objc  func handleComment()  {
        guard let post = self.posts else { return  }
    delgate?.didTapPost(post: post)
    }
    
    @objc func handleLike(){
        delgate?.didLike(for: self)
    }
}
