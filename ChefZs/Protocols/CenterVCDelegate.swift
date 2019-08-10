//
//  CenterVCDelegate.swift
//  ChefZs
//
//  Created by Daniel Duan on 8/8/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import Foundation
import UIKit

protocol CenterVCDelegate {
    func toogleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
