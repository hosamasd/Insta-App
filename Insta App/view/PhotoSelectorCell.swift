//
//  PhotoSelectorCell.swift
//  Insta App
//
//  Created by hosam on 4/25/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    let fullImage:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = UIColor.lightGray
        
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
