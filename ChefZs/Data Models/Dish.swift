//
//  Dish.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/1/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DSerializable {
    init?(dictionary:[String:Any])
}

struct Dish {
    var name: String
    var date: String
    var id: String
    var totalCount: [String]
    var smallCount: [String]
    var mediumCount: [String]
    var largeCount: [String]
    var fruitCount: [String]
    var waterCount: [String]
    var schools: [String: [String]]
    
    var dictionary:[String:Any] {
        return [
            "name":name,
            "date":date,
            "id":id,
            "totalCount":totalCount,
            "smallCount":smallCount,
            "mediumCount":mediumCount,
            "largeCount":largeCount,
            "fruitCount":fruitCount,
            "waterCount":waterCount,
            "schools":schools
        ]
    }
}

extension Dish : DSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let date = dictionary["date"] as? String,
            let id = dictionary["id"] as? String,
            let totalCount = dictionary["totalCount"] as? [String],
            let smallCount = dictionary["smallCount"] as? [String],
            let mediumCount = dictionary["mediumCount"] as? [String],
            let largeCount = dictionary["largeCount"] as? [String],
            let fruitCount = dictionary["fruitCount"] as? [String],
            let waterCount = dictionary["waterCount"] as? [String],
            let schools = dictionary["schools"] as? [String: [String]] else {return nil}
        
        self.init(name: name, date: date, id: id, totalCount: totalCount, smallCount: smallCount, mediumCount: mediumCount, largeCount: largeCount, fruitCount: fruitCount, waterCount: waterCount, schools: schools)
    }
}

