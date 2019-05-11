//
//  InOrOut.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class InOrOut: Condition {
    enum Values: String, Codable {
    case indoors = "indoors"
    case outdoors = "outdoors"
    case covered = "covered"
    }
    
    static var values: [Values] = [.indoors, .covered, .outdoors]
    var value: Values?
    
    override var name: String {
        return value!.rawValue
    }
    
    var isOutdoors: Bool {
        return self.value != .indoors
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: Condition.CodingKeys.self)
        value = Values(rawValue: try container.decode(String.self, forKey: .value))!
    }
    
    init(_ value: Values = .indoors) {
        super.init()
        self.value = value
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Condition.CodingKeys.self)
        try container.encode(name, forKey: .value)
    }
}
