//
//  PaymentHistoryDish.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/14/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import Foundation
import RealmSwift

class PaymentHistoryDish: Object {
    @objc dynamic var childName: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var size: String = ""
    @objc dynamic var addOn: String = ""
    @objc dynamic var dishName: String = ""
    @objc dynamic var paymentMethod: String = ""
}
