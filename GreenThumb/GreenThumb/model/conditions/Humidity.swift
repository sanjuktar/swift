//
//  Humidity.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation
class Humidity: Conditions {
    enum Values: String, Codable {
    case high = "humid"
    case medium = "medium"
    case low = "dry"
    }
    
    static var values: [Values] = [.high, .medium, .low]
    var value: Values?
    
    override var name: String {
        return value!.rawValue 
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = Values(rawValue: try container.decode(String.self, forKey: .value))!
    }
    
    init(_ value: Values = .medium) {
        super.init()
        self.value = value
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .value)
    }
}
