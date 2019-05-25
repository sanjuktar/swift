//
//  ConditionsType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/24/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum ConditionsType: String, Codable, CaseIterable {
    case inOrOut
    case light
    case rain
    case humidity
    case wind
    
    var defaultValue: Conditions {
        switch self {
        case .inOrOut:
            return InOrOut()
        case .light:
            return LightExposure()
        case .rain:
            return Rain()
        case .humidity:
            return Humidity()
        case .wind:
            return Wind()
        }
    }
    
    static var indoorTypes: [ConditionsType] = [.inOrOut, .light, .humidity]
    static var outdoorTypes: [ConditionsType] = [.inOrOut, .light, .rain, .humidity, .wind]
}
