//
//  CommentModel.swift
//  Insta App
//
//  Created by hosam on 4/28/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

struct CommentModel {
    let text:String
    let uid:String
    let user:UserModel
    
    init(user:UserModel,dict: [String:Any]) {
        self.user = user
        self.text = dict["text"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
    }
}
