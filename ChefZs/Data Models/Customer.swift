//
//  Customer.swift
//  ChefZs
//
//  Created by Daniel Duan on 7/21/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Customer {
    var email: String
    var paymentMethod: String
    var school: String
    var childName: String
    
    var dictionary:[String:Any] {
        return [
            "email":email,
            "paymentMethod":paymentMethod,
            "school":school,
            "childName":childName
        ]
    }
}

extension Customer : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let email = dictionary["email"] as? String,
            let paymentMethod = dictionary["paymentMethod"] as? String,
            let school = dictionary["school"] as? String,
            let childName = dictionary["childName"] as? String else {return nil}
        
        self.init(email: email, paymentMethod: paymentMethod, school: school, childName: childName)
    }
}
