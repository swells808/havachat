//
//  UserService.swift
//  havachat
//
//  Created by Sean Wells on 5/22/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile:User?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:User?)->())) {
        let userRef = Database.database().reference().child("users/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:User?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let location = dict["location"] as? String?,
                let email = dict["email"] as? String?,
                let photoURL = dict["photoURL"] as? String?,
//                let url = URL(string:photoURL),
                let type = dict["type"] as? String? {
                userProfile = User(uid: snapshot.key, username: username, location: location, email: email, photoURL: photoURL, type: type)
            }
            completion(userProfile)
        })
        
    }
    
}
