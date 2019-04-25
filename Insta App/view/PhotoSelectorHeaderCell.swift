//
//  PhotoSelectorHeaderCell.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PhotoSelectorHeaderCell: UICollectionReusableView {
    
    lazy var selectedImage:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .cyan
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        im.isUserInteractionEnabled = true
        return im
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupViews()
    }
    
    func setupViews()  {
       
        addSubview(selectedImage)
        
        selectedImage.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
