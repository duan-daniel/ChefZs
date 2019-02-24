//
//  ViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 2/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round button corners
        signInButton.layer.cornerRadius = 20
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
    
    // MARK: - Disable Button 
    func configureTextFields() {
        // create an array of textfields
        let textFieldArray = [emailTextField, passwordTextField]
        
        // configure them...
        for textField in textFieldArray {
            // make sure you set the delegate to be self
            textField?.delegate = self
            // add a target to them
            textField?.addTarget(self, action: #selector(LoginViewController.updateTextField), for: .editingChanged)
        }
    }

    @objc func updateTextField() {
        // create an array of textFields
        let textFields = [emailTextField, passwordTextField]
        // create a bool to test if a textField is blank in the textFields array
        let oneOfTheTextFieldsIsBlank = textFields.contains(where: {($0?.text ?? "").isEmpty})
        if oneOfTheTextFieldsIsBlank {
            signInButton.isEnabled = false
            signInButton.alpha = 0.5
        } else {
            signInButton.isEnabled = true
            signInButton.alpha = 1.0
        }
    }
    
    // MARK: - Buttons Tapped Methods
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // sign in user with Firebase
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                // go to home screen
                self.performSegue(withIdentifier: "goToHomeFromSignIn", sender: self)
            }
            else {
                
                //TODO: Let users know that the password is incorrect
                //TODO: Add loading animation
                print("error found")
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // segue to register screen
        self.performSegue(withIdentifier: "goToSignUpScreen", sender: self)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
}

