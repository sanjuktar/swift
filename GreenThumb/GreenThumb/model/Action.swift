//
//  Action.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class Action: IdedObj {
    enum CodingKeys: String, CodingKey {
        case id
        case desc
    }
    
    static var manager: ActionManager? {
        return AppDelegate.current?.actions!
    }
    var id: UniqueId
    var desc: String
    var hashValue: Int {
        return id.djb2hash
    }
    
    static func ==(_ lhs: Action, _ rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UniqueId.self, forKey: .id)
        desc = try container.decode(String.self, forKey: .desc)
    }
    
    init() {
        id = (Action.manager?.newId())!
        desc = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(desc, forKey: .desc)
    }
    
    func persist() throws {
        try Documents.instance?.store(self, as: id)
        try Action.manager?.add(self)
    }
    
    func unpersist() throws {
        try Documents.instance?.remove(id)
        try Action.manager?.remove(self)
    }
}

struct CodableAction: Codable {
    enum ActionType: String, Codable {
        case unknown = "Unknown"
        case water = "Water"
        case fertilize = "Fertilize"
        case sunExposure = "Sun exposure"
        
        /*var type: Any.Type {
            switch self {
            case .water: return Water.self
            case .fertilize: return Fertilize.self
            case .sunExposure: return Sun.self
            case .unknown: return Action.self
            }
        }*/
        
        static func value(of action: Any) -> ActionType? {
            switch action {
            case is Water: return .water
            case is Fertilize: return .fertilize
            case is Sun: return .sunExposure
            default: return nil
            }
        }
    }
    
    enum ActionKey: String, CodingKey {
        case type
        case action
    }
    
    var type: ActionType
    var action: Action
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionKey.self)
        type = try container.decode(ActionType.self, forKey: .type)
        switch type {
        case .water:
            action = try container.decode(Water.self, forKey: .action)
        case .fertilize:
            action = try container.decode(Fertilize.self, forKey: .action)
        case .sunExposure:
            action = try container.decode(Sun.self, forKey: .action)
        default:
            action = Action()
        }
    }
    
    init(_ action: Action) {
        self.action = action
        switch action {
        case is Water: self.type = .water
        case is Fertilize: self.type = .fertilize
        case is Sun: self.type = .sunExposure
        default: self.type = .unknown
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ActionKey.self)
        try container.encode(type, forKey: .type)
        switch type {
        case .water: try container.encode((action as! Water), forKey: .action)
        case .fertilize: try container.encode((action as! Fertilize), forKey: .action)
        case .sunExposure: try container.encode((action as! Sun), forKey: .action)
        default: break
        }
    }
}
