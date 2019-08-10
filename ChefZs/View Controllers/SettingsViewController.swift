//
//  SettingsViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/8/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        signOutButton.layer.cornerRadius = 10
        
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if ((user) != nil) {
                self.emailLabel.text = user?.email
            }
            else {
                print("no user is signed in")
            }
        }
        
    }
    
    @IBAction func paymentButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func schoolButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
//        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
//            self.signOut()
//        }))
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alertController, animated: true, completion: nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let error {
            print("failed to sign out with error..", error)
        }
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
