//
//  AddToOrderViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/4/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth

// TODO: grey-out button until all fields are in

class AddToOrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - Picker View Protocol Stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if sizeTextField.isFirstResponder {
            return sizePickerData.count
        }
        else if schoolTextField.isFirstResponder {
            return schoolPickerData.count
        }
        else if paymentTextField.isFirstResponder {
            return paymentPickerData.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if sizeTextField.isFirstResponder {
            return sizePickerData[row]
        }
        else if schoolTextField.isFirstResponder {
            return schoolPickerData[row]
        }
        else if paymentTextField.isFirstResponder {
            return paymentPickerData[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sizeTextField.isFirstResponder {
            sizeTextField.text = sizePickerData[row]
            size = sizePickerData[row]
        }
        else if schoolTextField.isFirstResponder {
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
    let sizePickerData = ["Medium", "Large"]
    let schoolPickerData = ["CMS", "Miller", "MVHS", "Lynbrook", "CHS", "Hyde", "HHS"]
    let paymentPickerData = ["PayPal", "Cash", "Check"]
    weak var pickerView: UIPickerView?
    
    // MARK: - @IBOutlets
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var ChildNameTextField: HoshiTextField!
    @IBOutlet weak var addToOrderBtn: UIButton!
    
    
    // MARK: CustomerDish variables
    var dish: Dish!
    var name = ""
    var day = ""
    var size = ""
    var school = ""
    var paymentMethod = ""
    var customerEmail = ""
    var childName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allow tap on screen to remove text field input from screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // UIPICKER
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sizeTextField.delegate = self
        schoolTextField.delegate = self
        paymentTextField.delegate = self
        
        sizeTextField.inputView = pickerView
        schoolTextField.inputView = pickerView
        paymentTextField.inputView = pickerView
        
        self.pickerView = pickerView
        
        addToOrderBtn.layer.cornerRadius = 20
        
        //TODO: Add day of week to navigationItem.title
        self.navigationItem.title = dish.date
        dishNameLabel.text = "Dish: \(dish.name)"
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        sizeTextField.inputAccessoryView = toolbar
        schoolTextField.inputAccessoryView = toolbar
        paymentTextField.inputAccessoryView = toolbar
        ChildNameTextField.inputAccessoryView = toolbar
        
        configureTextFields()
        updateTextFields()
        
    }
    
    // MARK: - Temporarily Disable Add to Order Button
    func configureTextFields() {
        // create an array of textfields
        let textFieldArray = [sizeTextField, schoolTextField, paymentTextField, ChildNameTextField]
        
        // configure them...
        for textField in textFieldArray {
            // make sure you set the delegate to be self
            textField?.delegate = self
            // add a target to them
            textField?.addTarget(self, action: #selector(AddToOrderViewController.updateTextFields), for: .editingChanged)
        }
    }
    
    @objc func updateTextFields() {
        // create an array of textFields
        let textFields = [sizeTextField, schoolTextField, paymentTextField, ChildNameTextField]
        // create a bool to test if a textField is blank in the textFields array
        let oneOfTheTextFieldsIsBlank = textFields.contains(where: {($0?.text ?? "").isEmpty})
        if oneOfTheTextFieldsIsBlank {
            addToOrderBtn.isEnabled = false
            addToOrderBtn.alpha = 0.5
        } else {
            addToOrderBtn.isEnabled = true
            addToOrderBtn.alpha = 1.0
        }
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func addToOrderPressed(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        if let user = user {
            self.customerEmail = user.email!
        }
        name = dish.name
        day = dish.date
        childName = ChildNameTextField.text!
        
        
        // MARK: - create CustomerDish object
        let dish = CustomerDish(name: self.name, day: self.day, size: self.size, school: self.school, paymentMethod: self.paymentMethod, customerEmail: self.customerEmail, childName: self.childName)
        SharedVariables.customerDishArray.append(dish)
        
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
