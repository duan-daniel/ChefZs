//
//  CheckBox.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/10/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import Foundation

class CheckBox {
    var section: Int
    var row: Int
    var status: Bool

    
    init(section: Int, row: Int, status: Bool) {
        self.section = section
        self.row = row
        self.status = status
    }
    
}
