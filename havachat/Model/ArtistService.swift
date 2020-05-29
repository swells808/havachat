//
//  ArtistService.swift
//  havachat
//
//  Created by Sean Wells on 5/24/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import Foundation
import Firebase 

class ArtistService {
    
    static var currentArtistProfile:Artist?
    
    static func observeArtistProfile(_ uid:String, completion: @escaping ((_ artistProfile:Artist?)->())) {
        let artistRef = Database.database().reference().child("artists/\(uid)")
        
        artistRef.observe(.value, with: { snapshot in
            var artistProfile:Artist?
            
            if let dict = snapshot.value as? [String:Any],
                let firstName = dict["firstName"] as? String,
                let lastName = dict["lastName"] as? String,
                let streetAddress = dict["streetAddress"] as? String,
                let cityAddress = dict["cityAddress"] as? String,
                let postalZip = dict["postalZip"] as? String,
                let country = dict["country"] as? String,
                let dob = dict["dob"] as? String,
                let idPictureUrl = dict["idPictureUrl"] as? String,
                let wPictureUrl = dict["wPictureUrl"] as? String,
                let bankAccount = dict["bankAccount"] as? String,
                let bankRouting = dict["bankRouting"] as? String,
                let bankSwift = dict["bankSwift"] as? String,
                let artistUsername = dict["artistUsername"] as? String,
                let artistLocation = dict["artistLocation"] as? String,
                let artistField = dict["artistField"] as? String,
                let artistHeadline = dict["artistHeadline"] as? String,
                let artistBio = dict["artistBio"] as? String,
                let lastOnline = dict["lastOnline"] as? String,
                let isConnected = dict["isConnected"] as? Bool,
                let profileImage = dict["profileImage"] as? String,
                let fiveMin = dict["fiveMin"] as? String,
                let tenMin = dict["tenMin"] as? String,
                let fifteenMin = dict["fifteenMin"] as? String,
                let isConfirmed = dict["isConfirmed"] as? Bool,
                let email = dict["email"] as? String,
                let type = dict["type"] as? String,
                let signUp = dict["signUp"] as? TimeInterval
            {  artistProfile = Artist(uid: snapshot.key, firstName: firstName, lastName: lastName, country: country, streetAddress: streetAddress, cityAddress: cityAddress, postalZip: postalZip, dob: dob, idPictureUrl: idPictureUrl, bankAccount: bankAccount, bankRouting: bankRouting, bankSwift: bankSwift, wPictureUrl: wPictureUrl, artistUsername: artistUsername, artistLocation: artistLocation, artistField: artistField, artistHeadline: artistHeadline, artistBio: artistBio, lastOnline: lastOnline, isConnected: isConnected, profileImage: profileImage, fiveMin: fiveMin, tenMin: tenMin, fifteenMin: fifteenMin, isConfirmed: isConfirmed, email: email, type: type, signUp: signUp)
            }
            completion(artistProfile)
        })
    }
    
}
