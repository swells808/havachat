//
//  PushNotificationManager.swift
//  havachat
//
//  Created by Sean Wells on 4/27/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

//class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
//    let userID: String
//    init(userID: String) {
//        self.userID = userID
//        super.init()
//    }
//    
//    func registerForPushNotifications() {
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM)
//            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//        }
//        UIApplication.shared.registerForRemoteNotifications()
//
//    }
//
//    func fetchCurrentToken() {
//        Messaging.messaging().delegate = self
//        
////        InstanceID.instanceID().instanceID { (result, error) in
////          if let error = error {
////            print("Error fetching remote instance ID: \(error)")
////          } else if let result = result {
////            print("Remote instance ID token: \(result.token)")
////            self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
////          }
////        }
//    }
//    
//    func updatePushTokenIfNeeded() {
//        if let token = Messaging.messaging().fcmToken {
//            let usersRef = Database.database().reference(withPath: "users").child(userID)
//            usersRef.setValue(["fcmToken": token], merge: true)
//        
//        }
//        
//        
//    }
//
//}
