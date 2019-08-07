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
    
    // firestore reference
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 160
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SharedVariables.customerDishArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewOrderCell", for: indexPath) as! PreviewOrderTableViewCell

        let customerDish = SharedVariables.customerDishArray[indexPath.row]
        cell.dateLabel.text = "Date: \(customerDish.day)"
        cell.dishLabel.text = "Dish: \(customerDish.name)"
        cell.paymentLabel.text = "Payment: \(customerDish.paymentMethod)"
        cell.schoolLabel.text = "School: \(customerDish.school)"
        cell.sizeLabel.text = "Size: \(customerDish.size)"

        return cell
    }
    
    @objc func fabTapped(_ button: UIButton) {
        print("button tapped")
        // MARK: - Write to firebase
        for CustomerDish in SharedVariables.customerDishArray {
            
            let id = CustomerDish.id
            let size = CustomerDish.size
            let email = CustomerDish.customerEmail
            let school = CustomerDish.school
            
            let ref = db.collection("foods").document(id)
            if size == "Medium" {
                print("MEDIUM COUNT GOOD YUH")
                ref.updateData([
                    "mediumCount": FieldValue.arrayUnion([email]),
                    "totalCount": FieldValue.arrayUnion([email]),
                    "schools.\(school)": FieldValue.arrayUnion([email])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            else {
                print("LARGE COUNT GOOD YUH")
                ref.updateData([
                    "largeCount": FieldValue.arrayUnion([email]),
                    "totalCount": FieldValue.arrayUnion([email]),
                    "schools.\(school)": FieldValue.arrayUnion([email])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }

        }
        
        
        // pop the view controller
        navigationController?.popViewController(animated: true)
        
        
        // MARK: remove all elements from CustomerDishArray
        SharedVariables.customerDishArray.removeAll()
    }
    

}
