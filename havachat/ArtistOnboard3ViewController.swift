//
//  ArtistOnboard3ViewController.swift
//  havachat
//
//  Created by Sean Wells on 5/21/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase

class ArtistOnboard3ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var fieldTextField: UITextField!
    @IBOutlet weak var headlineTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var primaryPictureImage: UIImageView!
    @IBOutlet weak var fiveMinLabel: UILabel!
    @IBOutlet weak var fiveMinStepper: UIStepper!
    @IBOutlet weak var tenMinLabel: UILabel!
    @IBOutlet weak var tenMinStepper: UIStepper!
    @IBOutlet weak var fifteenMinLabel: UILabel!
    @IBOutlet weak var fifteenMinStepper: UIStepper!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let firUser = Auth.auth().currentUser
    
    var image: UIImage? = nil
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        [usernameTextField, locationTextField, fieldTextField, headlineTextField, bioTextField].forEach { (field) in
            field?.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        }
        
    
    }
    
    
    @objc private func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let userName = usernameTextField.text, !userName.isEmpty,
            let locationName = locationTextField.text, !locationName.isEmpty,
            let artistField = fieldTextField.text, !artistField.isEmpty,
            let artistHeadline = headlineTextField.text, !artistHeadline.isEmpty,
            let artistBio = bioTextField.text, !artistBio.isEmpty
            else {
                doneButton.backgroundColor = .white
                doneButton.isEnabled = false
                return
        }
        doneButton.backgroundColor = UIColor(red: 21/255, green: 25/255, blue: 101/255, alpha: 1)
        doneButton.isEnabled = true
    }
    
    @IBAction func uploadImagePressed(_ sender: UIButton) {
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
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let imageSelected = self.image else {
            print("id image is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        var dict: Dictionary<String, Any> = [
            "artistUsername": usernameTextField.text,
            "artistLocation": locationTextField.text,
            "artistField": fieldTextField.text,
            "artistHeadline": headlineTextField.text,
            "artistBio": bioTextField.text,
            "fiveMin": fiveMinLabel.text,
            "tenMin": tenMinLabel.text,
            "fifteenMin": fifteenMinLabel.text,
            "pPictureUrl": "",
            "lastOnline": "",
            "isConnected": true,
            "isConfirmed": false,
            "type": "artist",
            "signUp": [".sv":"timestamp"],
            "email": self.firUser?.email
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
        performSegue(withIdentifier: "ArtistFinishedOnboardSegue", sender: self)
        
    }
    
}

extension ArtistOnboard3ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            image = imageSelected
            primaryPictureImage.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            image = imageOriginal
            primaryPictureImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


