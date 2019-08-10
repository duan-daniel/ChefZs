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
    let schoolPickerData = ["CMS", "Miller", "MVHS", "Lynbrook", "CHS", "Hyde", "HHS"]
    let paymentPickerData = ["PayPal", "Cash", "Check"]
    weak var pickerView: UIPickerView?
    

    var db: Firestore!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var paymentTextField: HoshiTextField!
    @IBOutlet weak var schoolTextField: HoshiTextField!
    
    var email = ""
    var paymentMethod = ""
    var school = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        // Round button corners
        createAccountButton.layer.cornerRadius = 20
        
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
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        
        // Disable Sign In Button until all Text Fields are filled in
        configureTextFields()
        updateTextField()
        
    }
    
    // MARK: - Temporarily Disable Sign Up Button
    
    func configureTextFields() {
        // create an array of textfields
        let textFieldArray = [emailTextField, passwordTextField]
        
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
        let textFields = [emailTextField, passwordTextField]
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
        email = emailTextField.text!
        password = passwordTextField.text!
        
        let newCustomer = Customer(email: email, paymentMethod: paymentMethod, school: school)
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                //MARK: - CREATE USERS COLLECTION HERE
                self.db.collection("customers").document(self.email).setData(newCustomer.dictionary) {
                    error in
                    
                    if let error = error {
                        print("error adding document: \(error)")
                    } else {
                        print("document added!")
                    }
                    
                }
                self.performSegue(withIdentifier: "goToHomeFromSignUp", sender: self)
            }
            
        }
    
    }
}
