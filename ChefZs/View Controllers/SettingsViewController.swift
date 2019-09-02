//
//  SettingsViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/8/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import TextFieldEffects
//import FirebaseAuth
//import FirebaseFirestore

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - Picker View Protocol Stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if schoolTextField.isFirstResponder {
            return schoolPickerData.count
        }
        else if paymentTextField.isFirstResponder {
            return paymentPickerData.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if schoolTextField.isFirstResponder {
            return schoolPickerData[row]
        }
        else if paymentTextField.isFirstResponder {
            return paymentPickerData[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if schoolTextField.isFirstResponder {
            schoolTextField.text = schoolPickerData[row]
            school = schoolPickerData[row]
        }
        else if paymentTextField.isFirstResponder {
            paymentTextField.text = paymentPickerData[row]
            paymentMethod = paymentPickerData[row]
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
    
    // MARK: - Picker View Data
    let schoolPickerData = ["CMS", "Miller", "MVHS", "Lynbrook", "CHS", "Hyde", "HHS", "Lawson", "KMS", "SHS"]
    let paymentPickerData = ["PayPal", "Cash", "Check"]
    weak var pickerView: UIPickerView?

    @IBOutlet weak var paymentTextField: HoshiTextField!
    @IBOutlet weak var schoolTextField: HoshiTextField!
    @IBOutlet weak var childNameTextField: HoshiTextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    var paymentMethod = ""
    var school = ""
    var childName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        saveButton.layer.cornerRadius = 20
        loadData()
        
        
        //allow tap on screen to remove text field input from screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // UIPICKER
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        schoolTextField.delegate = self
        paymentTextField.delegate = self
        
        schoolTextField.inputView = pickerView
        paymentTextField.inputView = pickerView
        
        self.pickerView = pickerView
        
        // Add done button to keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        paymentTextField.inputAccessoryView = toolbar
        schoolTextField.inputAccessoryView = toolbar
        childNameTextField.inputAccessoryView = toolbar
        
        
        // Disable Sign In Button until all Text Fields are filled in
        configureTextFields()
        updateTextField()
        
        
    }
    
    // MARK: - Disable Button
    func configureTextFields() {
        // create an array of textfields
        let textFieldArray = [paymentTextField, schoolTextField, childNameTextField]
        
        // configure them...
        for textField in textFieldArray {
            // make sure you set the delegate to be self
            textField?.delegate = self
            // add a target to them
            textField?.addTarget(self, action: #selector(SettingsViewController.updateTextField), for: .editingChanged)
        }
    }
    
    @objc func updateTextField() {
        // create an array of textFields
        let textFields = [paymentTextField, schoolTextField, childNameTextField]
        // create a bool to test if a textField is blank in the textFields array
        let oneOfTheTextFieldsIsBlank = textFields.contains(where: {($0?.text ?? "").isEmpty})
        if oneOfTheTextFieldsIsBlank {
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
        } else {
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        }
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func loadData() {
        
        paymentTextField.text = UserDefaults.standard.string(forKey: "customerPaymentMethod") ?? ""
        schoolTextField.text = UserDefaults.standard.string(forKey: "customerSchool") ?? ""
        childNameTextField.text = UserDefaults.standard.string(forKey: "customerChild") ?? ""
        
//        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if ((user) != nil) {
//                self.email = (user?.email)!
//                self.emailLabel.text = user?.email
//                self.db.collection("buyers").document(self.email)
//                    .addSnapshotListener { documentSnapshot, error in
//                        guard let document = documentSnapshot else {
//                            print("Error fetching document: \(error!)")
//                            return
//                        }
//                        guard let data = document.data() else {
//                            print("Document data was empty.")
//                            return
//                        }
//                        self.paymentMethod = data["paymentMethod"] as! String
//                        self.school = data["school"] as! String
//                        self.childName = data["childName"] as! String
//                        self.paymentTextField.text = self.paymentMethod
//                        self.schoolTextField.text = self.school
//                        self.childNameTextField.text = self.childName
//                }
//            }
//            else {
//                print("no user is signed in")
//            }
//        }
    }
    
//    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
//        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
//            self.signOut()
//        }))
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//        } catch let error {
//            print("failed to sign out with error..", error)
//        }
//    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
//        let customerPaymentMethod = paymentTextField.text
//        let customerSchool = schoolTextField.text
//        let customerChild = childNameTextField.text
        
        // save data with user defaults
        UserDefaults.standard.set(paymentTextField.text, forKey: "customerPaymentMethod")
        UserDefaults.standard.set(schoolTextField.text, forKey: "customerSchool")
        UserDefaults.standard.set(childNameTextField.text, forKey: "customerChild")
        
//        let newCustomer = Customer(email: customerEmail!, paymentMethod: customerPaymentMethod!, school: customerSchool!, childName: customerChild!)
//
//        self.db.collection("buyers").document(customerEmail!).setData(newCustomer.dictionary) {
//            error in
//
//            if let error = error {
//                print("error adding document: \(error)")
//            } else {
//                print("document added!")
//            }
//
//        }
        navigationController?.popViewController(animated: true)
    }

}
