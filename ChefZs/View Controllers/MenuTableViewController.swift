//
//  HomePageTableViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 2/24/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MenuTableViewController: UITableViewController {
    
    var dishArray: [Dish] = []
    var mondayDishArray = [Dish]()
    var tuesdayDishArray = [Dish]()
    var wednesdayDishArray = [Dish]()
    var thursdayDishArray = [Dish]()
    var fridayDishArray = [Dish]()
    
    // Firebase Reading Variables
    var documents: [DocumentSnapshot] = []
    var listener: ListenerRegistration!
    
    // MARK: - Read from Firestore
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("foods")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        
        self.query = baseQuery()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.listener =  query?.addSnapshotListener { (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            // results is all of the documents retrieved from "foods" collection
            let results = snapshot.documents.map { (document) -> Dish in
                if let dish = Dish(dictionary: document.data()) {
                    return dish
                } else {
                    fatalError("Unable to initialize type \(Dish.self) with dictionary \(document.data())")
                }
            }
            
            // clears the array of dishes
            self.mondayDishArray.removeAll()
            self.tuesdayDishArray.removeAll()
            self.wednesdayDishArray.removeAll()
            self.thursdayDishArray.removeAll()
            self.fridayDishArray.removeAll()
            
            self.dishArray = results
            self.documents = snapshot.documents
            
            // insert the specific dishes to respective dow
            for dish in self.dishArray {
                switch dish.id {
                case "mondayDish0":
                    self.mondayDishArray.insert(dish, at: 0)
                case "mondayDish1":
                    self.mondayDishArray.insert(dish, at: 1)
                case "tuesdayDish0":
                    self.tuesdayDishArray.insert(dish, at: 0)
                case "tuesdayDish1":
                    self.tuesdayDishArray.insert(dish, at: 1)
                case "wednesdayDish0":
                    self.wednesdayDishArray.insert(dish, at: 0)
                case "wednesdayDish1":
                    self.wednesdayDishArray.insert(dish, at: 1)
                case "thursdayDish0":
                    self.thursdayDishArray.insert(dish, at: 0)
                case "thursdayDish1":
                    self.thursdayDishArray.insert(dish, at: 1)
                case "fridayDish0":
                    self.fridayDishArray.insert(dish, at: 0)
                case "fridayDish1":
                    self.fridayDishArray.insert(dish, at: 1)
                default:
                    print("\(dish.id) is fucking sth up")
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.listener.remove()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        if (dishArray.count != 0) {
            let mondayHeader = "Monday \(mondayDishArray[0].date)"
            let tuesdayHeader = "Tuesday \(tuesdayDishArray[0].date)"
            let wednesdayHeader = "Wednesday \(wednesdayDishArray[0].date)"
            let thursdayHeader = "Thursday \(thursdayDishArray[0].date)"
            let fridayHeader = "Friday \(fridayDishArray[0].date)"
            let sections = [mondayHeader, tuesdayHeader, wednesdayHeader, thursdayHeader, fridayHeader]
            cell.headerLabel.text = sections[section]
        }
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mondayDishArray.count
        case 1:
            return tuesdayDishArray.count
        case 2:
            return wednesdayDishArray.count
        case 3:
            return thursdayDishArray.count
        default:
            return fridayDishArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        
        // Make pretty
        cell.viewOfContent.layer.cornerRadius = 10
        cell.viewOfContent.layer.masksToBounds = true
        
        if dishArray.count != 0 {
            switch indexPath.section {
            case 0:
                let dish = mondayDishArray[indexPath.row]
                cell.dishLabel.text = dish.name
            case 1:
                let dish = tuesdayDishArray[indexPath.row]
                cell.dishLabel.text = dish.name
            case 2:
                let dish = wednesdayDishArray[indexPath.row]
                cell.dishLabel.text = dish.name
            case 3:
                let dish = thursdayDishArray[indexPath.row]
                cell.dishLabel.text = dish.name
            default:
                let dish = fridayDishArray[indexPath.row]
                cell.dishLabel.text = dish.name
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "addToOrder" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destination = segue.destination as! AddToOrderViewController
//            destination.sectionIndex = indexPath.section
//            destination.rowIndex = indexPath.row
            
            switch indexPath.section {
            case 0:
                destination.dish = mondayDishArray[indexPath.row]
            case 1:
                destination.dish = tuesdayDishArray[indexPath.row]
            case 2:
                destination.dish = wednesdayDishArray[indexPath.row]
            case 3:
                destination.dish = thursdayDishArray[indexPath.row]
            case 4:
                destination.dish = fridayDishArray[indexPath.row]
            default:
                print("sth is fucking up")
            }
        }
        else if identifier == "previewOrder" {
            let destination = segue.destination as! PreviewOrderTableViewController
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
 

}
