//
//  CodableAction.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

struct CodableAction: Storable {
    
    enum CodingKeys: String, CodingKey {
        case version
        case type
        case action
    }
    
    var version: String
    var type: ActionType
    var action: Action
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        type = try container.decode(ActionType.self, forKey: .type)
        switch type {
        case .water:
            action = try container.decode(Water.self, forKey: .action)
        case .fertilize:
            action = try container.decode(Fertilize.self, forKey: .action)
        case .lightExposure:
            action = try container.decode(Light.self, forKey: .action)
        }
    }
    
    init(_ action: Action) throws {
        version = Defaults.version
        self.action = action
        switch action {
        case is Water:
            self.type = .water
        case is Fertilize:
            self.type = .fertilize
        case is Light:
            self.type = .lightExposure
        default:
            throw GenericError("Unable to determine Action type for \(action)")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(type, forKey: .type)
        switch type {
        case .water: try container.encode((action as! Water), forKey: .action)
        case .fertilize: try container.encode((action as! Fertilize), forKey: .action)
        case .lightExposure: try container.encode((action as! Light), forKey: .action)
        }
    }
}
