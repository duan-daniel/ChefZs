//
//  WelcomeViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/17/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {

    @IBOutlet weak var viewOfContent: UIView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOfContent.layer.cornerRadius = 20
        viewOfContent.layer.masksToBounds = true
        dismissButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonClicked(_ sender: UIButton) {
        SharedVariables.welcomeScreenDismissed = true
        dismiss(animated: true, completion: nil)
    }
    
}
