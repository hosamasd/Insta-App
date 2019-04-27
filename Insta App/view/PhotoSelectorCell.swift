//
//  PhotoSelectorCell.swift
//  Insta App
//
//  Created by hosam on 4/25/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PhotoSelectorCell: BaseCell {
    let fullImage:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = UIColor.lightGray
        
        return im
    }()
  
    
    override func setupViews(){
        super.setupViews()
        addSubview(fullImage)
        
        fullImage.fillSuperview()
    }
    
    
}
