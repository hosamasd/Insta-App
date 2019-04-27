//
//  PhotoSelectorHeaderCell.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PhotoSelectorHeaderCell: BaseCell {
    
    lazy var selectedImage:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .cyan
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        im.isUserInteractionEnabled = true
        return im
    }()
    
  
    
  override  func setupViews()  {
       super.setupViews()
        addSubview(selectedImage)
        
        selectedImage.fillSuperview()
    }
    
   
}
