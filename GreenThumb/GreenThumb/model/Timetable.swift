//
//  Timetable.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Timetable: Storable {
    enum CodingKeys: String, CodingKey {
        case version
        case action
        case frequency
    }
    
    var version: String
    var action: Action
    var freq: ActionFrequency
    var name: String {
        return "\(action.desc) \(freq.desc)"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        action = try container.decode(CodableAction.self, forKey: .action).action
        freq = try container.decode(ActionFrequency.self, forKey: .frequency)
    }
    
    init(_ action: Action, _ freq: ActionFrequency) {
        version = Timetable.defaultVersion
        self.action = action
        self.freq = freq
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(CodableAction(action), forKey: .action)
        try container.encode(freq, forKey: .frequency)
    }
}
