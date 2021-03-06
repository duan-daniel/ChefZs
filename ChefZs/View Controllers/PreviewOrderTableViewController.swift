//
//  PreviewOrderTableViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/5/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import StatefulViewController
import FirebaseFirestore
import RealmSwift

class PreviewOrderTableViewController: UITableViewController {
    
     // floating action button
        lazy var faButton: UIButton = {
            let button = UIButton(frame: .zero)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.5725490196, blue: 0.9137254902, alpha: 1)
            button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
            return button
        }()
    
    // for state controller
    let emptyStateView = UIView()
    let noStateView = UIView()
    
    // realm
    let realm = try! Realm()
    
    // firestore reference
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 230
        tableView.separatorStyle = .none
        
        db = Firestore.firestore()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createEmptyView()
        
        let stateMachine = ViewStateMachine(view: view)
        stateMachine["empty"] = emptyStateView
        stateMachine["none"] = noStateView
        
        // if there is at least one object in the customerDish array
        if SharedVariables.customerDishArray != nil && SharedVariables.customerDishArray.count > 0 {
            faButton.isEnabled = true
            faButton.alpha = 1.0
            stateMachine.transitionToState(.view("none"), animated: true) {
            }
        }
            // if customerDish array is empty, display the empty state view
        else {
            faButton.isEnabled = false
            faButton.alpha = 0.5
            stateMachine.transitionToState(.view("empty"), animated: true) {
            }
        }
        
        tableView.reloadData()
        
        if let view = UIApplication.shared.keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    func createEmptyView() {
        let emptyStateLabel = UILabel()
        emptyStateLabel.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 120)
        emptyStateLabel.text = "No Order Yet!"
        emptyStateLabel.textAlignment = .center
        
        emptyStateView.addSubview(emptyStateLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                if let view = UIApplication.shared.keyWindow, faButton.isDescendant(of: view) {
                    faButton.removeFromSuperview()
                }
    }
    
        func setupButton() {
            NSLayoutConstraint.activate([
                faButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
                faButton.heightAnchor.constraint(equalToConstant: 60),
                faButton.widthAnchor.constraint(equalToConstant: 314)
                ])
            faButton.setTitle("Confirm", for: .normal)
            faButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            faButton.layer.cornerRadius = 20
            faButton.layer.masksToBounds = true
    //        faButton.layer.borderColor = UIColor.lightGray.cgColor
    //        faButton.layer.borderWidth = 4
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedVariables.customerDishArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewOrderCell", for: indexPath) as! PreviewOrderTableViewCell
        
        cell.viewOfContent.layer.cornerRadius = 10
        cell.viewOfContent.layer.masksToBounds = true

        let customerDish = SharedVariables.customerDishArray[indexPath.row]
        cell.dateLabel.text = customerDish.day
        cell.dishLabel.text = customerDish.name
        cell.paymentLabel.text = "Payment: \(customerDish.paymentMethod)"
        cell.schoolLabel.text = "School: \(customerDish.school)"
        cell.sizeLabel.text = "Size: \(customerDish.size)"
        cell.addOnLabel.text = "Add-on: \(customerDish.addOn)"
        cell.orderForLabel.text = "Order For: \(customerDish.childName)"

        return cell
    }
    
    @objc func fabTapped(_ button: UIButton) {
        print("button tapped")
        
        // MARK: - reset checkboxes
        SharedVariables.checkBoxArray.removeAll()
        
        // MARK: - Write to firebase and to paymentHistoryDishArray
        for CustomerDish in SharedVariables.customerDishArray {
            
            let addOn = CustomerDish.addOn
            let id = CustomerDish.id
            let size = CustomerDish.size
//            let email = CustomerDish.customerEmail
            let specificSchool = CustomerDish.school + CustomerDish.size
            let childName = CustomerDish.childName
            let paymentMethod = CustomerDish.paymentMethod
            let profile = "\(childName)|\(paymentMethod)/\(addOn)"
            
            let pDish = PaymentHistoryDish()
            pDish.childName = childName
            pDish.date = CustomerDish.day
            pDish.dishName = CustomerDish.name
            pDish.paymentMethod = paymentMethod
            pDish.size = size
            pDish.addOn = addOn
            
            savePDish(dish: pDish)
            
            // Firebase Database
            let ref = db.collection("foods").document(id)
            if size == "Medium" {
                if addOn == "Fruit" {
                    ref.updateData([
                        "mediumCount": FieldValue.arrayUnion([profile]),
                        "totalCount": FieldValue.arrayUnion([profile]),
                        "fruitCount": FieldValue.arrayUnion([profile]),
                        "schools.\(specificSchool)": FieldValue.arrayUnion([profile])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
                else {
                    ref.updateData([
                        "mediumCount": FieldValue.arrayUnion([profile]),
                        "totalCount": FieldValue.arrayUnion([profile]),
                        "waterCount": FieldValue.arrayUnion([profile]),
                        "schools.\(specificSchool)": FieldValue.arrayUnion([profile])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
            else if size == "Large" {
                if addOn == "Fruit" {
                    ref.updateData([
                        "largeCount": FieldValue.arrayUnion([profile]),
                        "totalCount": FieldValue.arrayUnion([profile]),
                        "fruitCount": FieldValue.arrayUnion([profile]),
                        "schools.\(specificSchool)": FieldValue.arrayUnion([profile])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
                else {
                    ref.updateData([
                        "largeCount": FieldValue.arrayUnion([profile]),
                        "totalCount": FieldValue.arrayUnion([profile]),
                        "waterCount": FieldValue.arrayUnion([profile]),
                        "schools.\(specificSchool)": FieldValue.arrayUnion([profile])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
            else {
                if addOn == "Fruit" {
                    ref.updateData([
                        "smallCount": FieldValue.arrayUnion([profile]),
                        "totalCount": FieldValue.arrayUnion([profile]),
                        "fruitCount": FieldValue.arrayUnion([profile]),
                        "schools.\(specificSchool)": FieldValue.arrayUnion([profile])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
                else {
                    ref.updateData([
                        "smallCount": FieldValue.arrayUnion([profile]),
                        "totalCount": FieldValue.arrayUnion([profile]),
                        "waterCount": FieldValue.arrayUnion([profile]),
                        "schools.\(specificSchool)": FieldValue.arrayUnion([profile])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }

        }
        
        // MARK: remove all elements from CustomerDishArray
        SharedVariables.customerDishArray.removeAll()

        // show alert
        let alert = UIAlertController(title: "Dishes Ordered!",
                                      message: "All orders have been placed. Enjoy!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        
        }
    
    func savePDish(dish: PaymentHistoryDish) {
        do {
            try realm.write {
                realm.add(dish)
            }
        } catch {
            print("Error saving cateogry \(error)")
        }
    }

}
