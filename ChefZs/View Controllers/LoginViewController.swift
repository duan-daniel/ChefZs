//
//  ViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 2/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round button corners
        signInButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        
        // Add done button to keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
    }


    @IBAction func signInButtonTapped(_ sender: UIButton) {
        print("sign in button tapped")
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("sign up button tapped")

    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
}

