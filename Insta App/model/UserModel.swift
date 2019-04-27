//
//  UserModel.swift
//  Insta App
//
//  Created by hosam on 4/25/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class UserModel {
    let username:String
    let imageUrl:String
    let uid:String
    
    init(uids:String,dict: [String:Any]) {
        self.username = dict["username"] as? String ?? "none"
        self.imageUrl = dict["image-url"] as? String ?? "nil"
        self.uid = uids
    }
}
