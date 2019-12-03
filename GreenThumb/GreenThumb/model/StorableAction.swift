//
//  StorableAction.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class StorableAction: Storable {
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case type = "type"
        case action = "actionObj"
    }
    
    var version: String
    var action: Action?
    var name: String {
        return action!.name
    }
    var type: ActionType {
        return action!.type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        let actionName = try container.decode(String.self, forKey: .type)
        switch ActionCategory(typeName: actionName) {
        case .care:
            action = try CareType.decode(actionType: actionName, container)
        case .none:
            action = try NoAction(from: decoder)
        default:
            throw GenericError("Unknown action type \(actionName)")
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
        switch ActionCategory(type: type) {
        case .none:
            try container.encode(action as! NoAction, forKey: .action)
        case .care:
            try (action?.type as! CareType).encode(action: action!, &container)
        default:
            throw GenericError("Unable to encode action \(action!)")
        }
    }
}
