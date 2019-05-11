//
//  Conditions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class Condition: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case specifics = "specifics"
    }
    
    static func == (lhs: Condition, rhs: Condition) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String {fatalError("Must override")}
    
    required init(from decoder: Decoder) throws {}
    
    init() {}
    
    func encode(to encoder: Encoder) throws {
        fatalError("Abstract class initializer")
    }
    
    func  hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
