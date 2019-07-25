//
//  SignUpViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 2/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

//TOOD: fix Autolayout

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var db: Firestore!
    
    @IBOutlet weak var childFullNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var paymentPicker: UIPickerView!
    
    var childName = ""
    var email = ""
    var password = ""
    var paymentMethod = ""
    
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        // Connect the data
        self.paymentPicker.delegate = self
        self.paymentPicker.dataSource = self
        
        // Input the picker data into an array
        pickerData = ["Check", "Cash", "PayPal"]

        // Round button corners
        createAccountButton.layer.cornerRadius = 20
        
        // Add done button to keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        
        // Disable Sign In Button until all Text Fields are filled in
        configureTextFields()
        updateTextField()
        
    }
    
    // MARK: - Picker View methods
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paymentMethod = pickerData[row]
    }
    
    // MARK: - Temporarily Disable Sign Up Button
    
    func configureTextFields() {
        // create an array of textfields
        let textFieldArray = [childFullNameTextField, emailTextField, passwordTextField]
        
        // configure them...
        for textField in textFieldArray {
            // make sure you set the delegate to be self
            textField?.delegate = self
            // add a target to them
            textField?.addTarget(self, action: #selector(SignUpViewController.updateTextField), for: .editingChanged)
        }
    }
    
    @objc func updateTextField() {
        // create an array of textFields
        let textFields = [childFullNameTextField, emailTextField, passwordTextField]
        // create a bool to test if a textField is blank in the textFields array
        let oneOfTheTextFieldsIsBlank = textFields.contains(where: {($0?.text ?? "").isEmpty})
        if oneOfTheTextFieldsIsBlank {
            createAccountButton.isEnabled = false
            createAccountButton.alpha = 0.5
        } else {
            createAccountButton.isEnabled = true
            createAccountButton.alpha = 1.0
        }
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        childName = childFullNameTextField.text!
        email = emailTextField.text!
        password = passwordTextField.text!
        
        print("payment method = \(paymentMethod)")
        print("childName = \(childName)")
        print("email = \(email)")
        print("password = \(password)")
        
        let newCustomer = Customer(email: email, password: password, paymentMethod: paymentMethod, childName: childName)
        
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                // go to home screen
                self.performSegue(withIdentifier: "goToHomeFromSignUp", sender: self)
            }
            else {
                //TODO: Email already taken error
                print("error is found")
            }
        }
        
        //TODO: CREATE USERS COLLECTION HERE
        var ref: DocumentReference? = nil
        ref = self.db.collection("users").addDocument(data: newCustomer.dictionary) {
            error in
            
            if let error = error {
                print("error adding document: \(error.localizedDescription)")
            } else {
                print("document added! id: \(ref!.documentID)")
            }
        }
    

    }
}
