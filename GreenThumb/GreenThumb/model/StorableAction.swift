//
//  StorableAction.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

struct StorableAction: Storable {
    
    enum CodingKeys: String, CodingKey {
        case version
        case type
        case action
    }
    
    var version: String
    var action: Action
    var name: String {
        return action.name
    }
    var type: ActionType {
        return action.type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        let actionName = try container.decode(String.self, forKey: .type)
        let type = try CareType.create(actionName)
        switch type! {
        case CareType.none:
            action = try container.decode(NoAction.self, forKey: .action)
        case CareType.water:
            action = try container.decode(Water.self, forKey: .action)
        case CareType.fertilize:
            action = try container.decode(Fertilize.self, forKey: .action)
        case CareType.light:
            action = try container.decode(Light.self, forKey: .action)
        case CareType.move:
            action = try container.decode(Move.self, forKey: .action)
        case CareType.pestControl:
            action = try container.decode(PestControl.self, forKey: .action)
        case CareType.prune:
            action = try container.decode(Pruning.self, forKey: .action)
        default:
            throw GenericError("Action type \(actionName) not handled.")
        }
    }
    
    init(_ action: Action) throws {
        version = Defaults.version
        self.action = action
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(type.name, forKey: .type)
        switch type {
        case CareType.none: try container.encode(action as! NoAction, forKey: .action)
        case CareType.water: try container.encode((action as! Water), forKey: .action)
        case CareType.fertilize: try container.encode((action as! Fertilize), forKey: .action)
        case CareType.light: try container.encode((action as! Light), forKey: .action)
        case CareType.move: try container.encode(action as! Move, forKey: .action)
        case CareType.pestControl: try container.encode(action as! PestControl, forKey: .action)
        case CareType.prune: try container.encode(action as! Pruning, forKey: .action)
        default:
            throw GenericError("Unable to encode action of type \(type)")
        }
    }
}
