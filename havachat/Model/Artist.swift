//
//  Artist.swift
//  havachat
//
//  Created by Sean Wells on 4/28/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Artist {
    
    // MARK: - Properties
    
    let uid: String
    let firstName: String?
    let lastName: String?
    let country: String?
    let streetAddress: String?
    let cityAddress: String?
    let postalZip: String?
    let dob: String?
    let idPictureUrl: String?
    let bankAccount: String?
    let bankRouting: String?
    let bankSwift: String?
    let wPictureUrl: String?
    let artistUsername: String?
    let artistLocation: String?
    let artistField: String?
    let artistHeadline: String?
    let artistBio: String?
    let lastOnline: String?
    let isConnected: Bool?
    let profileImage: String?
    let fiveMin: String?
    let tenMin: String?
    let fifteenMin: String?
    let isConfirmed: Bool?
    let email: String?
    let type: String?
    let signUp: TimeInterval?
    
    // MARK: - Init
    
    init(uid: String, firstName: String?, lastName: String?, country: String?, streetAddress: String?, cityAddress: String?, postalZip: String?, dob: String?, idPictureUrl: String?, bankAccount: String?, bankRouting: String?, bankSwift: String?, wPictureUrl: String?, artistUsername: String?, artistLocation: String?, artistField: String?, artistHeadline: String?, artistBio: String?, lastOnline: String?, isConnected: Bool?, profileImage: String?, fiveMin: String?, tenMin: String?, fifteenMin: String?, isConfirmed: Bool?, email: String?, type: String?, signUp: TimeInterval?) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.country = country
        self.streetAddress = streetAddress
        self.cityAddress = cityAddress
        self.postalZip = postalZip
        self.dob = dob
        self.idPictureUrl = idPictureUrl
        self.bankAccount = bankAccount
        self.bankRouting = bankRouting
        self.bankSwift = bankSwift
        self.wPictureUrl = wPictureUrl
        self.artistUsername = artistUsername
        self.artistLocation = artistLocation
        self.artistField = artistField
        self.artistHeadline = artistHeadline
        self.artistBio = artistBio
        self.lastOnline = lastOnline
        self.isConnected = isConnected
        self.profileImage = profileImage
        self.fiveMin = fiveMin
        self.tenMin = tenMin
        self.fifteenMin = fifteenMin
        self.isConfirmed = isConfirmed
        self.email = email
        self.type = type
        self.signUp = signUp
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let country = dict["country"] as? String,
            let streetAddress = dict["streetAddress"] as? String,
            let cityAddress = dict["cityAddress"] as? String,
            let postalZip = dict["postalZip"] as? String,
            let dob = dict["dob"] as? String,
            let idPictureUrl = dict["idPictureUrl"] as? String,
            let bankAccount = dict["bankAccount"] as? String,
            let bankRouting = dict["bankRouting"] as? String,
            let bankSwift = dict["bankSwift"] as? String,
            let wPictureUrl = dict["wPictureUrl"] as? String,
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
            else { return nil }
        
        self.uid = snapshot.key
        self.firstName = firstName
        self.lastName = lastName
        self.country = country
        self.streetAddress = streetAddress
        self.cityAddress = cityAddress
        self.postalZip = postalZip
        self.dob = dob
        self.idPictureUrl = idPictureUrl
        self.bankAccount = bankAccount
        self.bankRouting = bankRouting
        self.bankSwift = bankSwift
        self.wPictureUrl = wPictureUrl
        self.artistUsername = artistUsername
        self.artistLocation = artistLocation
        self.artistField = artistField
        self.artistHeadline = artistHeadline
        self.artistBio = artistBio
        self.lastOnline = lastOnline
        self.isConnected = isConnected
        self.profileImage = profileImage
        self.fiveMin = fiveMin
        self.tenMin = tenMin
        self.fifteenMin = fifteenMin
        self.isConfirmed = isConfirmed
        self.email = email
        self.type = type
        self.signUp = signUp
        
    }
    
}
