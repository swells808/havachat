//
//  SettingsViewController.swift
//  havachat
//
//  Created by Sean Wells on 4/23/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SettingsViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.nameTextField.text = user?.displayName
                self.locationTextField.text = self.user.location
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "SettingsBackToStartSegue", sender: self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            showErrorAlert(error: nil)
            return
        }
        
        let newName = nameTextField.text
        let newLocation = locationTextField.text
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
        //changeRequest.locationName = newLocation
        changeRequest.commitChanges { (error) in
            if let error = error {
                self.showErrorAlert(error: error)
            } else {
                let ref = Database.database().reference()
                ref.child("users/\(user.uid)/username").setValue(newName?.lowercased())
                ref.child("users/\(user.uid)/displayname").setValue(newName)
                ref.child("users/\(user.uid)/location").setValue(newLocation)
                ref.child("users/\(user.uid)/type").setValue("fan")
                
                let alert = UIAlertController(title: "Success", message: "Your changes have been saved.", preferredStyle: .alert)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    alert.dismiss(animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.performSegue(withIdentifier: "FanHomeSegue", sender: self)
                })
            }
        }
    }
    
    func showErrorAlert(error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }

        let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            alert.dismiss(animated: true)
        })
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
