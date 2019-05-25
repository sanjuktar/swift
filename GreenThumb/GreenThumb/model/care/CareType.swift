//
//  CareType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum CareType: String, Codable, CaseIterable, CustomStringConvertible {
    case water = "Water"
    case fertilize = "Fertilize"
    case light = "Light exposure"
    case prune = "Prune"
    case move = "Move"
    case pestControl = "Pest Control"
    
    static var seasonal: [CareType] = [.water, .fertilize, .light, .pestControl]
    static var nonSeasonal: [CareType] = [.prune]
    
    var description: String {
        return rawValue
    }
}
