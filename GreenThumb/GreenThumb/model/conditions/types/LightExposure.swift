//
//  LightExposure.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class LightExposure: Conditions {
    enum Values: String, Codable {
    case any = "any"
    case fullSun = "full direct sun"
    case morningSun = "direct morning sun"
    case afternoonSun = "direct afternoon sun"
    case someDirectSun = "some direct sun"
    case bright = "bright indirect light"
    case mediumLight = "medium light"
    case lowLight = "low light"
    }
    
    static var values: [Values] = [.any, .fullSun, .someDirectSun, .bright, .mediumLight, .lowLight]
    var value: Values?
    override var name: String {
        return value!.rawValue
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: Conditions.CodingKeys.self)
        value = Values(rawValue: try container.decode(String.self, forKey: .value))!
    }
    
    init(_ value: Values = (Defaults.conditions[.light] as! LightExposure).value!) {
        super.init()
        self.value = value
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: Conditions.CodingKeys.self)
        try container.encode(name, forKey: .value)
    }
}
