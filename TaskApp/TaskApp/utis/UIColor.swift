//
//  UIColor.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/26/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func from(priority :Task.Priority) -> UIColor {
        switch priority {
        case .alert: return UIColor.red
        case .high: return UIColor.orange
        case .medium: return UIColor.darkGray
        case .low: return UIColor.cyan
        }
    }
    
    static func from(status :Task.Status) -> UIColor {
        switch status {
        case .new: return UIColor.black
        case .seen: return UIColor.gray
        case .inProgress: return UIColor.green
        case .done: return UIColor.lightGray
        case .forLater: return UIColor.brown
        case .quit: return UIColor.magenta
        }
    }
}
