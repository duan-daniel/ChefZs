//
//  SettingsViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/8/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseFirestore

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
    let schoolPickerData = ["CMS", "Miller", "MVHS", "Lynbrook", "CHS", "Hyde", "HHS"]
    let paymentPickerData = ["PayPal", "Cash", "Check"]
    weak var pickerView: UIPickerView?

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var paymentTextField: HoshiTextField!
    @IBOutlet weak var schoolTextField: HoshiTextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var db: Firestore!
    var email = ""
    var paymentMethod = ""
    var school = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
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
        
        
    }
    
    func loadData() {
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if ((user) != nil) {
                self.email = (user?.email)!
                self.emailLabel.text = user?.email
                self.db.collection("customers").document(self.email)
                    .addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        guard let data = document.data() else {
                            print("Document data was empty.")
                            return
                        }
                        self.paymentMethod = data["paymentMethod"] as! String
                        self.school = data["school"] as! String
                        self.paymentTextField.text = self.paymentMethod
                        self.schoolTextField.text = self.school
                }
            }
            else {
                print("no user is signed in")
            }
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let error {
            print("failed to sign out with error..", error)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let customerEmail = emailLabel.text
        let customerPaymentMethod = paymentTextField.text
        let customerSchool = schoolTextField.text
        let newCustomer = Customer(email: customerEmail!, paymentMethod: customerPaymentMethod!, school: customerSchool!)
        
        self.db.collection("customers").document(customerEmail!).setData(newCustomer.dictionary) {
            error in
            
            if let error = error {
                print("error adding document: \(error)")
            } else {
                print("document added!")
            }
            
        }
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
