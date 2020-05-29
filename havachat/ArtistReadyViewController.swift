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
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Firebase Database
//        userRef = Database.database().reference(withPath: "users")
        
//        if let user = Auth.auth().currentUser {
//            let rootRef = Database.database().reference()
//            let userRef = rootRef.child("users").child(user.uid)
//            setValue(welcomeText.text, forKey: ("Welcome \(currentUser?.username)"))
//        }
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "Incomming Chat", message: "Incomming call from Fan Justin Bieber", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let start = UIAlertAction(title: "Accept", style: .default) { (action) in
            self.performSegue(withIdentifier: "ArtistChatSegue", sender: self)
        }
        
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = UIImage(named:"justin-bieber-pic-circle")
        alert.view.addSubview(imgViewTitle)
        
        alert.addAction(start)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func setingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ArtistsSettingSegue", sender: self)
    }
    
    @IBAction func simulateChatPressed(_ sender: UIButton) {
        showActionSheet()
    }
    


}
