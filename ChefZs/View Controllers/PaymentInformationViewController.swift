//
//  PaymentInformationViewController.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/31/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit

class PaymentInformationViewController: UIViewController {

    
    @IBOutlet weak var viewOfContent: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOfContent.layer.cornerRadius = 20
        viewOfContent.layer.masksToBounds = true
        dismissButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    


}
