//
//  Wind.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class Wind: Conditions {
    enum Values: Codable, Equatable {
        case windy
        case calm
        case drafty(Bool)
        
        enum CodingKeys: String, CodingKey {
            case value = "value"
        }
        
        var name: String {
            switch self {
            case .windy:
                return "windy"
            case .calm:
                return "calm"
            case .drafty(let isWarm):
                return "drafty(\(isWarm ? "warm" : "cold"))"
            }
        }
        
        static func == (lhs: Wind.Values, rhs: Wind.Values) -> Bool {
            return lhs.name == rhs.name
        }
        
        static func get(_ string: String) -> Values? {
            switch string {
            case Values.windy.name:
                return .windy
            case Values.calm.name:
                return .calm
            case Values.drafty(true).name:
                return .drafty(true)
            case Values.drafty(false).name:
                return .drafty(false)
            default:
                return .calm
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let val = try container.decode(String.self, forKey: .value)
            self = Values.get(val)!
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .value)
        }
    }
    
    static var values: [Wind.Values] = [.windy, .calm, .drafty(false), .drafty(true)]
    var value: Values?
    
    override var name: String {
        switch value! {
        case .drafty(let isWarm):
            return "\(value!.name)(\(isWarm ? "warm" : "cold"))"
        default: return value!.name
        }
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let val = try container.decode(String.self, forKey: .value)
        switch val {
        case Values.windy.name:
            value = .windy
        case Values.calm.name:
            value = .calm
        case Values.drafty(true).name:
            value = .drafty(try container.decode(Bool.self, forKey: .specifics))
        default:
            throw GenericError("Unable to load wind conditions.")
        }
    }
    
    init(_ value: Values = (Defaults.conditions[ConditionsType.wind] as! Wind).value!) {
        super.init()
        self.value = value
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value!.name, forKey: .value)
        switch value! {
        case .drafty(let isWarm):
            try container.encode(isWarm, forKey: .specifics)
        default:
            break
        }
    }
}
