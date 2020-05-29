//
//  Chat.swift
//  havachat
//
//  Created by Sean Wells on 5/24/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import Firebase

class Chat {
    
    //MARK: - Properties
    
    let chatID: String
    let token: String
    let fanID: String
    let artistID: String
    let artistUsername: String
    let fanUsername: String
    let fanPhotoURL: String 
    let channelName: String
    let handle: AuthStateDidChangeListenerHandle
    let timeStamp: TimeInterval
    let userID: UInt
    let remoteID: UInt
    let chatTime: Int
    let chatCost: Int
    
    // MARK: - Init
    
    init(chatID:String, token:String, fanID: String, artistID: String, artistUsername: String, fanUsername: String, fanPhotoURL: String, channelName: String, handle: AuthStateDidChangeListenerHandle, timeStamp: TimeInterval, userID: UInt, remoteID: UInt, chatTime: Int, chatCost: Int) {
        self.chatID = chatID
        self.token = token
        self.fanID = fanID
        self.artistID = artistID
        self.artistUsername = artistUsername
        self.fanUsername = fanUsername
        self.fanPhotoURL = fanPhotoURL
        self.channelName = channelName
        self.handle = handle
        self.timeStamp = timeStamp
        self.userID = userID
        self.remoteID = remoteID
        self.chatTime = chatTime
        self.chatCost = chatCost
    }
    
}

