//
//  Checkbox.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/26/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class Checkbox : UIButton {
    var isChecked :Bool = false {
        didSet {
            titleLabel?.text = isChecked ? "☑" : "☐"
        }
    }
    
    convenience init(isChecked :Bool) {
        self.init(type: .roundedRect)
        self.titleLabel?.textColor = UIColor.darkGray
        self.isChecked = isChecked
    }
}
