//
//  Timetable.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Timetable: Storable, CustomStringConvertible {
    enum CodingKeys: String, CodingKey {
        case version
        case action
        case frequency
    }
    
    var version: String
    var action: UniqueId
    var freq: ActionFrequency
    var description: String {
        return "\(action) \(freq)"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        action = try container.decode(UniqueId.self, forKey: .action)
        freq = try container.decode(ActionFrequency.self, forKey: .frequency)
    }
    
    init(_ action: UniqueId, _ freq: ActionFrequency) {
        version = Defaults.version
        self.action = action
        self.freq = freq
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(action, forKey: .action)
        try container.encode(freq, forKey: .frequency)
    }
}
