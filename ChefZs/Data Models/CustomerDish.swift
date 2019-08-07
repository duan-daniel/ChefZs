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
    var school: String
    var paymentMethod: String
    var customerEmail: String
    var childName: String
    var id: String
    
    init(name: String, day: String, size: String, school: String, paymentMethod: String, customerEmail: String, childName: String, id: String) {
        self.name = name
        self.day = day
        self.size = size
        self.school = school
        self.paymentMethod = paymentMethod
        self.customerEmail = customerEmail
        self.childName = childName
        self.id = id
    }

}
