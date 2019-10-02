//
//  Conditions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class Conditions: Storable, Hashable {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case value = "value"
        case specifics = "specifics"
    }
    
    var version: String = Defaults.version
    var name: String {fatalError("Must override")}
    
    static func == (lhs: Conditions, rhs: Conditions) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func decode(from decoder: Decoder) throws -> Conditions {
        return try StorableConditions(from: decoder).condition
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
    }
    
    init() {}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
    }
    
    func  hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
