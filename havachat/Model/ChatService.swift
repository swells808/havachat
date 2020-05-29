//
//  ChatService.swift
//  havachat
//
//  Created by Sean Wells on 5/24/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import Foundation
import Firebase

class ChatService {
    
    static var currentChat: Chat?
    
    static func observeChat(_ chatID:String, completion: @escaping ((_ chatProfile:Chat?)->())) {
        let chatRef = Database.database().reference().child("chats/\(chatID)")
        
        chatRef.observe(.value, with: { snapshot in
            var chatProfile:Chat?
            
            if let dict = snapshot.value as? [String:Any],
                let token = dict["token"] as? String,
                let fanID = dict["fanID"] as? String,
                let artistID = dict["artistID"] as? String,
                let artistUsername = dict["artistUsername"] as? String,
                let fanUsername = dict["fanUsername"] as? String,
                let fanPhotoURL = dict["fanPhotoURL"] as? String,
                let channelName = dict["channelName"] as? String,
                let handle = dict["handle"] as? AuthStateDidChangeListenerHandle,
                let timeStamp = dict ["timeStamp"] as? TimeInterval,
                let userID = dict["userID"] as? UInt,
                let remoteID = dict["remoteID"] as? UInt,
                let chatTime = dict["chatTime"] as? Int,
                let chatCost = dict["chatCost"] as? Int
            {
                chatProfile = Chat(chatID: snapshot.key, token: token, fanID: fanID, artistID: artistID, artistUsername: artistUsername, fanUsername: fanUsername, fanPhotoURL: fanPhotoURL, channelName: channelName, handle: handle, timeStamp: timeStamp, userID: userID, remoteID: remoteID, chatTime: chatTime, chatCost: chatCost)
            }
            completion(chatProfile)
        })
    }
}


