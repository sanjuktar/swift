//
//  Rain.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class Rain: Conditions {
    enum Values: String, Codable {
    case rainy = "rainy"
    case dry = "dry"
    }
    
    static var values: [Values] = [.rainy, .dry]
    var value: Values?
    
    override var name: String {
        return value!.rawValue
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: Conditions.CodingKeys.self)
        value = Values(rawValue: try container.decode(String.self, forKey: .value))!
    }
    
    init(_ value: Values = .dry) {
        super.init()
        self.value = value
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: Conditions.CodingKeys.self)
        try container.encode(name, forKey: .value)
    }
}
