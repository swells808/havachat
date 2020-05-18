//
//  Fan.swift
//  havachat
//
//  Created by Sean Wells on 4/28/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit

class Fan: NSObject {
    
    // MARK: - Properties
    var uid: String
    var displayname: String?
    var email: String?
    var type: String?
    var username: String?
    var location: String?
    var photoURL: URL?
    
    // MARK: - Init
    init(uid: String, displayname: String?, email: String?, type: String?, username: String?, location: String?, photoURL: URL? ) {
        self.uid = uid
        self.displayname = displayname
        self.email = email
        self.type = type
        self.username = username
        self.location = location
        self.photoURL = photoURL
    }
}
