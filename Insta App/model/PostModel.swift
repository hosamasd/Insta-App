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
    let caption:String
    let user:UserModel
    init(user:UserModel,dict: [String:Any]) {
        self.imageUrl = dict["image-url"] as? String ?? ""
        self.user = user
        self.caption = dict["caption"] as? String ?? ""
    }
    
}
