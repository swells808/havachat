//
//  ArtistOnboard1ViewController.swift
//  havachat
//
//  Created by Sean Wells on 5/20/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase

class ArtistOnboard1ViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityAddressTextField: UITextField!
    @IBOutlet weak var postalAddressTextField: UITextField!
    @IBOutlet weak var countryAddressTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var idPhotoImage: UIImageView!
    @IBOutlet var allTextFields: [UITextField]!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let datePicker = UIDatePicker()
    let dateFormatter = Date()
    let firUser = Auth.auth().currentUser
    
    var selectedCountry: String?
    var listOfCountries: [String] = []
    var image: UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPickerViewCountry()
        dismissPickerViewCountry()
        getListOfCountries()
        createDatePicker()
        
        saveButton.backgroundColor = .white
        saveButton.isEnabled = false
        [firstNameTextField, lastNameTextField, streetAddressTextField, cityAddressTextField, postalAddressTextField].forEach { (field) in
            field?.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        }
     
    }
    
    @IBAction func uploadIdButtonPressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
            "firstName": firstNameTextField.text,
            "lastName": lastNameTextField.text,
            "streetAddress": streetAddressTextField.text,
            "cityAddress": cityAddressTextField.text,
            "postalZip": postalAddressTextField.text,
            "country": countryAddressTextField.text,
            "dob": dobTextField.text,
            "idPictureUrl": ""
        ]
        
        let storageRef = Storage.storage().reference(forURL: "gs://havachat-c96a4.appspot.com")
        let storageProfileRef = storageRef.child("id").child(firUser!.uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            storageProfileRef.downloadURL(completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    dict["idPictureUrl"] = metaImageUrl
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
            performSegue(withIdentifier: "ArtistOnboardTwoSegue", sender: self)
        }
    
    @objc private func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let streetAddress = streetAddressTextField.text, !streetAddress.isEmpty,
            let cityAddress = cityAddressTextField.text, !cityAddress.isEmpty,
            let postalZip = postalAddressTextField.text, !postalZip.isEmpty
            else {
                saveButton.backgroundColor = .white
                saveButton.isEnabled = false
                return
        }
        saveButton.backgroundColor = UIColor(red: 21/255, green: 25/255, blue: 101/255, alpha: 1)
        saveButton.isEnabled = true
    }

}


extension ArtistOnboard1ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //Pickerview for country
    func createPickerViewCountry() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
           countryAddressTextField.inputView = pickerView
    }
    func dismissPickerViewCountry() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       countryAddressTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    func getListOfCountries(){
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            listOfCountries.append(name)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCountries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfCountries[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = listOfCountries[row]
        countryAddressTextField.text = selectedCountry
    }
    
    //Date Picker
    func createDatePicker () {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        dobTextField.inputAccessoryView = toolbar
        dobTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dobTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
        
}

extension ArtistOnboard1ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            image = imageSelected
            idPhotoImage.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            image = imageOriginal
            idPhotoImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

