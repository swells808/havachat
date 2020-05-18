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
    
    var firstName: String?
    var lastName: String?
    var selectedCountry: String?
    var listOfCountries: [String] = []
    var streetAddress: String?
    var cityName: String?
    var postalZip: String?
    var selectedBirthdate: String?
    var bankAccount: String?
    var bankRouting: String?
    var bankSwift: String?
    var artistUsername: String?
    var artistLocation: String?
    
    
    let datePicker = UIDatePicker()
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference(withPath: "Users")

    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var idPhoto: UIImageView!
    @IBOutlet weak var wPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPickerViewCountry()
        dismissPickerViewCountry()
        getListOfCountries()
        createDatePicker()
    }
    
    
    @IBAction func uploadIdButton(_ sender: Any) {
    }
    @IBAction func uploadWButton(_ sender: Any) {
    }
    @IBAction func uploadArtistProfileImageButton(_ sender: Any) {
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
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
