//
//  PhotoSelectorHeaderCell.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PhotoSelectorHeaderCell: UICollectionReusableView {
    
    let selectedImage:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .blue
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupViews()
    }
    
    func setupViews()  {
       
        addSubview(selectedImage)
        
        selectedImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 200))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
