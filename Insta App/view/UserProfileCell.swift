//
//  UserProfileCell.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    var posts:PostModel?  {
        didSet{
            print(1)
            guard let post = posts else { return  }
            self.fullImage.loadImageUsingCacheWithUrlString(post.imageUrl)
        }
    }
    
    let fullImage:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .purple
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
         setupViews()
        
    }
    
    fileprivate func setupViews(){
        addSubview(fullImage)
        
        fullImage.fillSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
