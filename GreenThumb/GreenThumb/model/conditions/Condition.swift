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
    
    var version: String = Location.defaultVersion
    var name: String {fatalError("Must override")}
    
    static func == (lhs: Conditions, rhs: Conditions) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func decode(from decoder: Decoder) throws -> Conditions {
        return try CodableConditions(from: decoder).condition
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

class CodableConditions: Storable {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case type = "type"
        case condition = "condition"
    }
    
    var version: String
    var type: Location.ConditionsType
    var condition: Conditions
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        type = try container.decode(Location.ConditionsType.self, forKey: .type)
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
        version = CodableAction.defaultVersion
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
        try container.encode(type, forKey: .type)
        try container.encode(condition, forKey: .condition)
    }
}
