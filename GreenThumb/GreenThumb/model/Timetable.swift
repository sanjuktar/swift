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
        case version = "version"
        case name = "name"
        case action = "action"
        case frequency = "frequency"
    }
    
    var version: String
    var name: String = ""
    var action: Action
    var freq: ActionFrequency
    var description: String {
        return "\(action) \(freq)"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        name = try container.decode(String.self, forKey: .name)
        action = try container.decode(StorableAction.self, forKey: .action).action!
        freq = try container.decode(ActionFrequency.self, forKey: .frequency)
    }
    
    init(name: String = "", _ action: Action, _ freq: ActionFrequency) {
        version = Defaults.version
        self.name = name
        self.action = action
        self.freq = freq
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
        try container.encode(StorableAction(action), forKey: .action)
        try container.encode(freq, forKey: .frequency)
    }
}
