//
//  ArtistSettingsViewController.swift
//  havachat
//
//  Created by Sean Wells on 4/29/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase

class ArtistSettingsViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var fieldTextField: UITextField!
    @IBOutlet weak var headlineTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fiveMinLabel: UILabel!
    @IBOutlet weak var tenMinLabel: UILabel!
    @IBOutlet weak var fifteenMinLabel: UILabel!
    
    let firUser = Auth.auth().currentUser
    
    var image: UIImage? = nil
    var handle: AuthStateDidChangeListenerHandle?
    var user: User!
    var artist: Artist!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("artists").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, artist) in
            if self.user != nil {
                self.usernameTextField.text = self.artist.artistUsername
                self.locationTextField.text = self.artist.artistLocation
                self.fieldTextField.text = self.artist.artistField
                self.headlineTextField.text = self.artist.artistHeadline
                self.bioTextField.text = self.artist.artistBio
//                self.profileImage = self.artist.profileImage
                self.fiveMinLabel.text = self.artist.fiveMin
                self.tenMinLabel.text = self.artist.tenMin
                self.fifteenMinLabel.text = self.artist.fifteenMin
            } else {
//                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "ArtistSettingsLogoutSegue", sender: self)
        } catch {
            print(error.localizedDescription)
        }
    }
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func fiveMinStepperPressed(_ sender: UIStepper) {
        fiveMinLabel.text = Double(sender.value).description
    }
    @IBAction func tenMinStepperPressed(_ sender: UIStepper) {
        tenMinLabel.text = Double(sender.value).description
    }
    @IBAction func fifteenMinStepperPressed(_ sender: UIStepper) {
        fifteenMinLabel.text = Double(sender.value).description
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let imageSelected = self.image else {
                print("id image is nil")
                return
            }
            
            guard let imageData = imageSelected.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            var dict: Dictionary<String, Any> = [
                "uid": firUser!.uid,
                "userName": usernameTextField.text,
                "locationName": locationTextField.text,
                "artistField": fieldTextField.text,
                "artistHeadline": headlineTextField.text,
                "artistBio": bioTextField.text,
                "fiveMin": fiveMinLabel.text,
                "tenMin": tenMinLabel.text,
                "fifteenMin": fifteenMinLabel.text,
                "pPictureUrl": ""
            ]
            
            let storageRef = Storage.storage().reference(forURL: "gs://havachat-c96a4.appspot.com")
            let storageProfileRef = storageRef.child("profile").child(firUser!.uid)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if let metaImageUrl = url?.absoluteString {
                        dict["pPictureUrl"] = metaImageUrl
                        print(metaImageUrl)
                        
                        Database.database().reference().child("artists")
                            .child(self.firUser!.uid).updateChildValues(dict, withCompletionBlock: {
                                (error, ref) in
                                if error == nil {
                                    print("Done")
                                }
                            })
                        }
                    
                    })
                }
            let alert = UIAlertController(title: "Settings Saved!", message: "Your settings have been saved. Thank You.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
            
    }
    

}

extension ArtistSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            image = imageSelected
            profileImage.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            image = imageOriginal
            profileImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
