//
//  ActionType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/23/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum ActionType: String, Codable, CaseIterable, CustomStringConvertible {
    case water = "Water"
    case fertilize = "Fertilize"
    case lightExposure = "Light exposure"
    
    var description: String {
        return rawValue
    }
}
