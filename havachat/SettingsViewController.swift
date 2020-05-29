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
import Photos

class SettingsViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var ref = Database.database().reference()
    var image: UIImage? = nil
    let firUser = Auth.auth().currentUser
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var userProfileImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                let userID = Auth.auth().currentUser?.uid
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    let location = value?["location"] as? String ?? ""
                    let email = value?["email"] as? String ?? ""
                    let photoURL = value?["photoURL"] as? String ?? ""
                    let type = value?["type"] as? String ?? ""
                    let user = User(uid: user!.uid  , username: username, location: location, email: email, photoURL: photoURL, type: type)
                    
                    self.nameTextField.text = user.username
                    self.locationTextField.text = user.location
                })
                
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
    

    
    
    @IBAction func didTapPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
        
        guard let imageSelected = self.image else {
            print("profile image is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            showErrorAlert(error: nil)
            return
        }
        
        let newName = nameTextField.text
        let newLocation = locationTextField.text
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
//        changeRequest.locationName = newLocation
        changeRequest.commitChanges { (error) in
            if let error = error {
                self.showErrorAlert(error: error)
            } else {

                let ref = Database.database().reference()
                ref.child("users/\(user.uid)/username").setValue(newName?.lowercased())
                ref.child("users/\(user.uid)/displayname").setValue(newName)
                ref.child("users/\(user.uid)/location").setValue(newLocation)
                ref.child("users/\(user.uid)/type").setValue("fan")
                
                let storageRef = Storage.storage().reference(forURL: "gs://havachat-c96a4.appspot.com")
                let storageProfileRef = storageRef.child("profile").child(user.uid)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    storageProfileRef.downloadURL(completion: { (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            var idPictureUrl = ""
                            idPictureUrl = metaImageUrl
                            let dict: Dictionary<String, Any> = ["userPhotoUrl": idPictureUrl]
                            print(metaImageUrl)
                            
                            Database.database().reference().child("users").child(user.uid).updateChildValues(dict, withCompletionBlock: {
                                    (error, ref) in
                                    if error == nil {
                                        print("Done")
                                    }
                                })
                            }
                        
                        })
                    }
                
                
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

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            image = imageSelected
            userProfileImage.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            image = imageOriginal
            userProfileImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
