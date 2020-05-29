//
//  ArtistOnboard2ViewController.swift
//  havachat
//
//  Created by Sean Wells on 5/21/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase

class ArtistOnboard2ViewController: UIViewController {

    @IBOutlet weak var bankAccountTextField: UITextField!
    @IBOutlet weak var bankRoutingTextField: UITextField!
    @IBOutlet weak var bankSwiftTextField: UITextField!
    @IBOutlet weak var wPhotoImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var w8TextView: UITextView!
    @IBOutlet weak var w9TextView: UITextView!
    
    let firUser = Auth.auth().currentUser
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        [bankAccountTextField, bankRoutingTextField].forEach { (field) in
            field?.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        }
       
    }
    
    func updateW8() {
        let path = "https://apps.irs.gov/app/picklist/list/formsInstructions.html?value=w-8&criteria=formNumber"
        let text = w8TextView.text ?? ""
        let attributedString = NSMutableAttributedString.makeHyperlink(for: path, in: text, as: "w8")
        let font = w8TextView.font
        w8TextView.attributedText = attributedString
        w8TextView.font = font
    }
    
    func updateW9() {
        let path = "https://www.irs.gov/pub/irs-pdf/fw9.pdf"
        let text = w9TextView.text ?? ""
        let attributedString = NSMutableAttributedString.makeHyperlink(for: path, in: text, as: "w9")
        let font = w9TextView.font
        w9TextView.attributedText = attributedString
        w9TextView.font = font 
    }
    
    @objc private func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let bankAccount = bankAccountTextField.text, !bankAccount.isEmpty,
            let bankRouting = bankRoutingTextField.text, !bankRouting.isEmpty
            else {
                nextButton.backgroundColor = .white
                nextButton.isEnabled = false
                return
        }
        nextButton.backgroundColor = UIColor(red: 21/255, green: 25/255, blue: 101/255, alpha: 1)
        nextButton.isEnabled = true
    }
    
    @IBAction func wImagePressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard let imageSelected = self.image else {
            print("id image is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        var dict: Dictionary<String, Any> = [
            "bankAccount": bankAccountTextField.text,
            "bankRouting": bankRoutingTextField.text,
            "bankSwift": bankSwiftTextField.text,
            "wPictureUrl": ""
        ]
        
        let storageRef = Storage.storage().reference(forURL: "gs://havachat-c96a4.appspot.com")
        let storageProfileRef = storageRef.child("wImages").child(firUser!.uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            storageProfileRef.downloadURL(completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    dict["wPictureUrl"] = metaImageUrl
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
        performSegue(withIdentifier: "ArtistOnboardThreeSegue", sender: self)
    }
    


}

extension ArtistOnboard2ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            image = imageSelected
            wPhotoImage.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            image = imageOriginal
            wPhotoImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
