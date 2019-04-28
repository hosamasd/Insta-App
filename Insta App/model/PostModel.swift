//
//  PostModel.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import Foundation

struct PostModel {
    var id:String?
    
    let imageUrl:String
    let caption:String
    let user:UserModel
    let creationDate:Date
    var hasLiked:Bool = false
    
    init(user:UserModel,dict: [String:Any]) {
        self.imageUrl = dict["image-url"] as? String ?? ""
        self.user = user
        self.caption = dict["caption"] as? String ?? ""
        let secondsFrom1970 = dict["creationDate"] as? Double ?? 0
        
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
}
