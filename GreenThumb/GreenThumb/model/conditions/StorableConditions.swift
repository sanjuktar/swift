//
//  StorableConditions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

struct StorableConditions: Storable {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case name = "name"
        case type = "type"
        case condition = "condition"
    }
    
    var version: String
    var type: ConditionsType
    var condition: Conditions
    var name: String {
        return condition.name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        type = try container.decode(ConditionsType.self, forKey: .type)
        switch type {
        case .inOrOut:
            condition = try container.decode(InOrOut.self, forKey: .condition)
        case .light:
            condition = try container.decode(LightExposure.self, forKey: .condition)
        case .rain:
            condition = try container.decode(Rain.self, forKey: .condition)
        case .humidity:
            condition = try container.decode(Humidity.self, forKey: .condition)
        case .wind:
            condition = try container.decode(Wind.self, forKey: .condition)
        }
    }
    
    init(_ condition: Conditions) throws {
        version = Defaults.version
        self.condition = condition
        switch condition {
        case is InOrOut: type = .inOrOut
        case is LightExposure: type = .light
        case is Rain: type = .rain
        case is Humidity: type = .humidity
        case is Wind: type = .wind
        default: throw GenericError("Unknown conditions type: \(condition.name)")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(condition, forKey: .condition)
    }
}
