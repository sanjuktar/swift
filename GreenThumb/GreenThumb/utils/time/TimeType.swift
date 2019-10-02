//
//  TimeType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/24/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum TimeType: String, Codable, CaseIterable, CustomStringConvertible {
    case anytimeEver = "anytime"
    case anytimeOfDay = "any time of day"
    case anytimeOfYear = "any time of year"
    case date = "date"
    case timeOfDay = "time of day"
    case timeOfYear = "time of year"
    case timeWindow = "time window"
    
    var description: String {
        return rawValue
    }
}
