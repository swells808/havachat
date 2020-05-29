//
//  User.swift
//  havachat
//
//  Created by Sean Wells on 5/1/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {

    // MARK: - Properties

    let uid: String
    let username: String?
    let location: String?
    let email: String?
    let photoURL: String?
    let type: String?

    // MARK: - Init

    init(uid: String, username: String?, location: String?, email: String?, photoURL: String?, type: String?) {
        self.uid = uid
        self.username = username
        self.location = location
        self.email = email
        self.photoURL = photoURL
        self.type = type
    }
    
//    init?(snapshot: DataSnapshot) {
//        guard let dict = snapshot.value as? [String : Any],
//            let username = dict["username"] as? String,
//            let location = dict["location"] as? String,
//            let email = dict["email"] as? String,
//            let photoURL = dict["photoURL"] as? String,
//            let type = dict["type"] as? String
//            else { return nil }
//
//        self.uid = snapshot.key
//        self.username = username
//        self.location = location
//        self.email = email
//        self.photoURL = photoURL
//        self.type = type 
//    }
}
