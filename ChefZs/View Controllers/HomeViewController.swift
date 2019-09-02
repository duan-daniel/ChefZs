//
//  HomeViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/27/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var paymentInstructionsButton: UIButton!
    @IBOutlet weak var appInstructionsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentInstructionsButton.layer.cornerRadius = 20
        appInstructionsButton.layer.cornerRadius = 20
        
        
    }
    
    
    @IBAction func paymentInstructionsButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showPaymentDirections", sender: nil)
    }
    
    @IBAction func appInstructionsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showAppDirections", sender: nil)
    }
    
    
}
