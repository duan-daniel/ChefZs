//
//  CustomerDish.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/5/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import Foundation

class CustomerDish {
    var name: String
    var day: String
    var size: String
    var addOn: String
    var school: String
    var paymentMethod: String
    var childName: String
    var id: String
    
    init(name: String, day: String, size: String, addOn: String, school: String, paymentMethod: String, childName: String, id: String) {
        self.name = name
        self.day = day
        self.size = size
        self.addOn = addOn
        self.school = school
        self.paymentMethod = paymentMethod
        self.childName = childName
        self.id = id
    }

}
