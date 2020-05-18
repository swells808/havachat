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

    // MARK: - Init

    init(uid: String, username: String?, location: String?) {
        self.uid = uid
        self.username = username
        self.location = location
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
            let location = dict["location"] as? String
            else { return nil }

        self.uid = snapshot.key
        self.username = username
        self.location = location
    }
}
