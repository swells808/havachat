//
//  ArtistReadyViewController.swift
//  havachat
//
//  Created by Sean Wells on 4/29/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ArtistReadyViewController: UIViewController {
    
    var currentUser: User?
    var userRef: DatabaseReference!
    

    @IBOutlet weak var welcomeText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Firebase Database
//        userRef = Database.database().reference(withPath: "users")
        
        if let user = Auth.auth().currentUser {
            let rootRef = Database.database().reference()
            let userRef = rootRef.child("users").child(user.uid)
            setValue(welcomeText.text, forKey: ("Welcome \(currentUser?.username)"))
        }
    }
    

    @IBAction func readyClick(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
