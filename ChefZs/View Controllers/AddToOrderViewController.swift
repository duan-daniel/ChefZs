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
import FirebaseFirestore

class AddToOrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    // MARK: - Picker View Protocol Stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if sizeTextField.isFirstResponder {
            return sizePickerData.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if sizeTextField.isFirstResponder {
            return sizePickerData[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sizeTextField.isFirstResponder {
            sizeTextField.text = sizePickerData[row]
            size = sizePickerData[row]
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
    
    // MARK: - Picker View Data
    let sizePickerData = ["Medium", "Large"]
    weak var pickerView: UIPickerView?
    
    
    // MARK: - @IBOutlets
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeTextField: HoshiTextField!
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
    var id = ""
    
    var sectionIndex = 0
    var rowIndex = 0
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        //allow tap on screen to remove text field input from screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // UIPICKER
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sizeTextField.delegate = self
        
        sizeTextField.inputView = pickerView
        
        self.pickerView = pickerView
        
        addToOrderBtn.layer.cornerRadius = 20
        
        //TODO: Add day of week to navigationItem.title
        switch sectionIndex {
        case 0:
            self.navigationItem.title = "Monday"
        case 1:
            self.navigationItem.title = "Tuesday"
        case 2:
            self.navigationItem.title = "Wenesday"
        case 3:
            self.navigationItem.title = "Thursday"
        default:
            self.navigationItem.title = "Friday"
        }
        dishNameLabel.text = dish.name
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        sizeTextField.inputAccessoryView = toolbar
        ChildNameTextField.inputAccessoryView = toolbar
        
        loadData()
        
//        configureTextFields()
//        updateTextFields()
        
    }
    
    func loadData() {
        let user = Auth.auth().currentUser
        if let user = user {
            self.customerEmail = user.email!
        }
        db.collection("buyers").document(customerEmail).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("data empty")
                return
            }
            self.paymentMethod = data["paymentMethod"] as! String
            self.school = data["school"] as! String
            self.childName = data["childName"] as! String
            self.ChildNameTextField.text = self.childName
        }
    }
    
    
    
    // MARK: - Temporarily Disable Add to Order Button
    func configureTextFields() {
        // create an array of textfields
        let textFieldArray = [ChildNameTextField]
        
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
        let textFields = [ChildNameTextField]
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

        name = dish.name
        switch sectionIndex {
        case 0:
            day = "Monday | \(dish.date)"
        case 1:
            day = "Tuesday | \(dish.date)"
        case 2:
            day = "Wednesday | \(dish.date)"
        case 3:
            day = "Thursday | \(dish.date)"
        default:
            day = "Friday | \(dish.date)"
        }
        childName = ChildNameTextField.text!
        id = dish.id
        
        if (paymentMethod != "") {
            // MARK: - create CustomerDish object
            let dish = CustomerDish(name: self.name, day: self.day, size: self.size, school: self.school, paymentMethod: self.paymentMethod, customerEmail: self.customerEmail, childName: self.childName, id: self.id)
            SharedVariables.customerDishArray.append(dish)
            
            let garbage = CheckBox(section: sectionIndex, row: rowIndex, status: true)
            SharedVariables.checkBoxArray.append(garbage)
            
            navigationController?.popViewController(animated: true)
        }
    }

}
