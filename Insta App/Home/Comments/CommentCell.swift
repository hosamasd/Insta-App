//
//  CommentCell.swift
//  Insta App
//
//  Created by hosam on 4/28/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class CommentCell: BaseCell {
    var comments:CommentModel? {
        didSet{
            guard let comment = comments else { return  }
            guard let user = comments?.user else { return  }
           
            self.profileImage.loadImageUsingCacheWithUrlString(user.imageUrl)
            
            let attributeText = NSMutableAttributedString(string: "\(user.username): ", attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributeText.append(NSAttributedString(string: "\(comment.text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
            self.textLabel.attributedText = attributeText
        }
    }
    let textLabel:UITextView = {
        let la = UITextView()
        la.isScrollEnabled = false
       la.font = UIFont.systemFont(ofSize: 16)
        
        return la
    }()
    let profileImage:UIImageView = {
        let im = UIImageView()
        im.layer.cornerRadius = 20
        im.clipsToBounds = true
        return im
    }()
    override func setupViews() {
        backgroundColor = .white
        addSubview(textLabel)
        addSubview(profileImage)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 8, bottom: 0, right: 0),size: .init(width: 40, height: 40))
        textLabel.anchor(top: topAnchor, leading: profileImage.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8),size: .init(width: 0, height: 0))
    }
    
    
    
}
