//
//  ArtistCreateUserViewController.swift
//  havachat
//
//  Created by Sean Wells on 5/1/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ArtistCreateUserViewController: UIViewController {

    var selectedCountry: String?
    var listOfCountries: [String] = []
    var fiveMinSelected: [String] = []
    var tenMinSelected: [String] = []
    var fifteenMinSelected: [String] = []
    var idImageURL = ""
    var wImageURL = ""
    var pImageURL = ""
    var pImageSelected: UIImage? = nil
 
    let datePicker = UIDatePicker()
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference(withPath: "Artists")
    let dateFormatter = Date()
    let storePricing: [String] = ["0.99", "1.99", "2.99", "3.99", "4.99", "5.99", "6.99", "7.99", "8.99", "9.99", "10.99", "11.99", "12.99", "13.99", "14.99", "15.99", "16.99", "17.99", "18.99", "19.99", "20.99", "21.99", "22.99", "23.99", "24.99", "25.99", "26.99", "27.99", "28.99", "29.99", "30.99", "31.99", "32.99", "33.99", "34.99", "35.99", "36.99", "37.99", "38.99", "39.99", "40.99", "41.99", "42.99", "43.99", "44.99", "45.99", "46.99", "47.99", "48.99", "49.99", "54.99", "59.99", "64.99", "69.99", "74.99", "79.99", "84.99", "89.99", "94.99", "99.99", "109.99", "119.99", "129.99", "139.99", "149.99", "159.99", "169.99", "179.99", "189.99", "199.99", "209.99", "219.99", "229.99", "239.99", "249.99", "299.99", "349.99", "399.99", "449.99", "499.99", "599.99", "699.99", "799.99", "899.99", "999.99"]

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var postalZipTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var idPhoto: UIImageView!
    @IBOutlet weak var wPhoto: UIImageView!
    @IBOutlet weak var bankAccountTextField: UITextField!
    @IBOutlet weak var bankRoutingTextField: UITextField!
    @IBOutlet weak var bankSwiftTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var artistLocationTextField: UITextField!
    @IBOutlet weak var pPhoto: UIImageView!
    @IBOutlet weak var fiveValueLabel: UILabel!
    @IBOutlet weak var tenValueLabel: UILabel!
    @IBOutlet weak var fifteenValueLabel: UILabel!
    @IBOutlet weak var fiveStepper: UIStepper!
    @IBOutlet weak var tenStepper: UIStepper!
    @IBOutlet weak var fifteenStepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPickerViewCountry()
        dismissPickerViewCountry()
        getListOfCountries()
        createDatePicker()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func alert() {
        let msg = "Your haven't filled out every field in your user form. Please complete it before you can continue"
        let alertView = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occurred.")
        }))
        present(alertView, animated: true, completion: nil)
    }
    @objc func dismissAlert () {
        self.dismiss(animated: true, completion: nil)
    }
        
    
    @IBAction func uploadIdButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func uploadWButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func uploadArtistProfileImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func fiveStepperValueChanged(_ sender: UIStepper) {
        fiveValueLabel.text = Double(sender.value).description
    }
    @IBAction func tenStepperValueChanged(_ sender: UIStepper) {
        tenValueLabel.text = Double(sender.value).description
    }
    @IBAction func fifteenStepperValueCHanged(_ sender: UIStepper) {
        fifteenValueLabel.text = Double(sender.value).description
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let imageData = pImageSelected?.jpegData(compressionQuality: 0.4) else {
            return
        }
            
        guard let firUser = Auth.auth().currentUser,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let country = selectedCountry,
            let streetAddress = streetAddressTextField.text,
            let cityName = cityNameTextField.text,
            let postalZip = postalZipTextField.text,
            let dob = birthdateTextField.text,
            let bankAccount = bankAccountTextField.text,
            let bankRouting = bankRoutingTextField.text,
            let bankSwift = bankSwiftTextField.text,
            let userName = userNameTextField.text,
            let locationName = artistLocationTextField.text,
            let fiveName = fiveValueLabel.text,
            let tenName = tenValueLabel.text,
            let fifteenName = fifteenValueLabel.text,
            !firstName.isEmpty else { return }
        var userAttrs = ["uid": firUser.uid, "firstName": firstName, "lastName": lastName, "country": country, "streetAddress": streetAddress, "cityName": cityName, "postalZip": postalZip, "dob": dob, "bankAccount": bankAccount, "bankRouting": bankRouting, "bankSwift": bankSwift, "username": userName, "locationName": locationName, "profileImageUrl": "", "fiveMin": fiveName, "tenMin": tenName, "fifteenMin": fifteenName, "userType": "Artist", "accountConfirmed": "false", "inChat": "false"]
        let storageRef = Storage.storage().reference(forURL: "gs://havachat-c96a4.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(firUser.uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
        }
        storageProfileRef.downloadURL(completion: { (url, error) in
            if let metaImageUrl = url?.absoluteString {
                userAttrs["profileImageUrl"] = metaImageUrl
                
                let ref = Database.database().reference().child("artists").child(firUser.uid)
                        ref.setValue(userAttrs) { (error, ref) in
                            if let error = error {
                                assertionFailure(error.localizedDescription)
                                return
                            }
                            self.performSegue(withIdentifier: "ArtistWaitScreenSegue", sender: self)
                //            ref.observeSingleEvent(of: .value) { (snapshot) in
                //                let user = User(snapshot: snapshot)
                //            }
                        }
            }
        })
        
    
    }
    
}


extension ArtistCreateUserViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //Pickerview for country
    func createPickerViewCountry() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
           countryTextField.inputView = pickerView
    }
    func dismissPickerViewCountry() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       countryTextField.inputAccessoryView = toolBar
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
        countryTextField.text = selectedCountry
    }
    
    //Date Picker
    func createDatePicker () {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        birthdateTextField.inputAccessoryView = toolbar
        birthdateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthdateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
        
}

extension ArtistCreateUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            pImageSelected = imageSelected
            pPhoto.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            pImageSelected = imageOriginal
            pPhoto.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
