//
//  UserDatabase.swift
//  Insta App
//
//  Created by hosam on 4/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
extension Database {
    
    func loadUserInfo(uid: String, completion: @escaping (UserModel)->())  {
    
        Database.database().reference(withPath: "Users").child(uid).observeSingleEvent(of: .value) { (sanpshot) in
            guard let dictionaries = sanpshot.value as?[String:Any] else {return}
           
            let user = UserModel(uids: uid, dict: dictionaries)
            
              completion(user)
            }
            
        
        }
    
}
