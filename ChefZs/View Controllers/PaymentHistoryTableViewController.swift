//
//  PaymentHistoryTableViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/14/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import RealmSwift

class PaymentHistoryTableViewController: UITableViewController {
    
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    
    var dishesArray: Results<PaymentHistoryDish>?
    let realm = try! Realm()
    
    override func viewDidAppear(_ animated: Bool) {
        loadDishes()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDishes()
        tableView.reloadData()
        tableView.rowHeight = 150
        
        if dishesArray?.count == 0 {
            clearBarButton.isEnabled = false
        }
        else {
            clearBarButton.isEnabled = true
        }
        
    }
    
    func loadDishes() {
        dishesArray = realm.objects(PaymentHistoryDish.self)
        if dishesArray?.count == 0 {
            clearBarButton.isEnabled = false
        }
        else {
            clearBarButton.isEnabled = true
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishesArray?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentHistoryTableViewCell
        let dish = dishesArray?[indexPath.row]
        
        cell.childNameTextField.text = dish?.childName
        cell.dateLabel.text = dish?.date
        cell.dishLabel.text = dish?.dishName
        cell.paymentLabel.text = dish?.paymentMethod
        cell.sizeLabel.text = dish?.size

        return cell
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Clear History?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (_) in
            self.clearHistory()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func clearHistory() {
        if dishesArray != nil {
            for dish in dishesArray! {
                do {
                    try realm.write {
                        realm.delete(dish)
                    }
                } catch {
                    print("error deleting dish, \(error)")
                }
            }
            tableView.reloadData()
        }
    }
    
}
