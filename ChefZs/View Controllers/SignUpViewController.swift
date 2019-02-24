//
//  SignUpViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 2/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullNameTextField: HoshiTextField!
    @IBOutlet weak var childFullNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Round button corners
        signUpButton.layer.cornerRadius = 20
        
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
        let textFieldArray = [fullNameTextField, childFullNameTextField, emailTextField, passwordTextField]
        
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
        let textFields = [fullNameTextField, childFullNameTextField, emailTextField, passwordTextField]
        // create a bool to test if a textField is blank in the textFields array
        let oneOfTheTextFieldsIsBlank = textFields.contains(where: {($0?.text ?? "").isEmpty})
        if oneOfTheTextFieldsIsBlank {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
        } else {
            signUpButton.isEnabled = true
            signUpButton.alpha = 1.0
        }
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // register user with Firebase
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                // go to home screen
                self.performSegue(withIdentifier: "goToHomeFromSignUp", sender: self)
            }
            else {
                print("error is found")
            }
        }
    }
}
