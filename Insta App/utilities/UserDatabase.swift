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
    
    func loadAllUserOnly(uids: String,completion: @escaping ([UserModel])->())  {
        
        Database.database().reference(withPath: "Users").child(uids).observe(.childAdded) { (snapshot) in
           
                guard let dictionaries = snapshot.key as?[String:Any] else {return}
            guard let dict = dictionaries.values as? [String:Any] else {return}
                let user = UserModel( dict: dict)
                
                completion([user])
        }
        }
    

    
}

extension Date {
    func getElapsedInterval(dates:Date) -> String {
        
     let interval = Calendar.current.dateComponents([ .hour, .minute, .second], from: dates, to: Date())
        
        if let hour = interval.hour, hour > 0 {
    return hour == 1 ? "\(hour)" + " " + "hour ago" :
    "\(hour)" + " " + "hours ago"
        }else if let mintue = interval.minute, mintue > 0 {
            return mintue == 1 ? "\(mintue)" + " " + "hour ago" :
                "\(mintue)" + " " + "mintues ago"
        }else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second ago" :
                "\(second)" + " " + "seconds ago"
        } else {
            return "a moment ago"
            
        }
        
    }

}
