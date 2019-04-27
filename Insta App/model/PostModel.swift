//
//  PostModel.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import Foundation

struct PostModel {
    let imageUrl:String
    
    init(dict: [String:Any]) {
        self.imageUrl = dict["image-url"] as? String ?? ""
    }
    
}
