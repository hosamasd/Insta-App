//
//  UserProfileCell.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class UserProfileCell: BaseCell {
    
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
    
   
    
    
    override func setupViews(){
    super.setupViews()
        addSubview(fullImage)
        
        fullImage.fillSuperview()
    }
   
    
}
