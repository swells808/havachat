//
//  ArtistListViewData.swift
//  havachat
//
//  Created by Sean Wells on 4/27/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol DocumentSerializable {
    init?(dictionary: [String:Any])
}

struct ArtistInfo {
    var username: String
    var location: String
    var field: String
    var lastOnline: Date
    var isConnected: Bool
    var profileImage: UIImage
    var fiveMin: Int
    var tenMin: Int
    var fifteenMin: Int
    var isConfirmed: Bool
    var email: String
    var type: String
    
    var dictionary: [String:Any] {
        return [
            "username": username,
            "location": location,
            "field": field,
            "lastOnline": lastOnline,
            "isConnected": isConnected,
            "profileImage": profileImage,
            "fiveMin": fiveMin,
            "tenMin": tenMin,
            "fifteenMin": fifteenMin,
            "isConfirmed": isConfirmed,
            "email": email,
            "type": type
        ]
    }
}

extension ArtistInfo: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let username = dictionary["username"] as? String,
            let location = dictionary["location"] as? String,
            let field = dictionary["field"] as? String,
            let lastOnline = dictionary["lastOnline"] as? Date,
            let isConnected = dictionary["isConnected"] as? Bool,
            let profileImage = dictionary["profileImage"] as? UIImage,
            let fiveMin = dictionary["fiveMin"] as? Int,
            let tenMin = dictionary["tenMin"] as? Int,
            let fifteenMin = dictionary["fifteenMin"] as? Int,
            let isConfirmed = dictionary["isConfirmed"] as? Bool,
            let email = dictionary["email"] as? String,
            let type = dictionary["type"] as? String
            else { return nil }
        
        self.init(username: username, location: location, field: field, lastOnline: lastOnline, isConnected: isConnected, profileImage: profileImage, fiveMin: fiveMin, tenMin: tenMin, fifteenMin: fifteenMin,isConfirmed: isConfirmed, email: email, type: type)
    }
}

struct ArtistInfoListViewData {
    var artistsInfo: [ArtistInfo]
}
