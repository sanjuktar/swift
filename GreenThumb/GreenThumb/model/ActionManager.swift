//
//  ActionManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/9/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class ActionManager: IdedObjManager<Action> {
    enum CodingKeys: String, CodingKey {
        case name
        case actions
        case idGenerator
    }
    
    static var instance :ActionManager {
        return (AppDelegate.current?.actions!)!
    }
    static var defaultName = "Action.Manager"
    var actions: [UniqueId:CodableAction] = [:]
    var log: Log? = AppDelegate.current?.log
        
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let ids = try container.decode([UniqueId].self, forKey: .actions)
        try ids.forEach{actions[$0] = try Documents.instance?.retrieve($0, as: CodableAction.self)}
        idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
    }
    
    init(_ name: String = ActionManager.defaultName, lastId: Int = 0) {
        super.init(name, "Action")
        self.actions = [:]
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(actions.keys.map{$0}, forKey: .actions)
        try container.encode(idGenerator, forKey: .idGenerator)
    }
    
    static func load(name: String = defaultName) throws -> ActionManager {
        return try (Documents.instance?.retrieve(name, as: ActionManager.self))!
    }
    
    override func commit() throws {
        try Documents.instance?.store(self, as: name)
    }
    
    override func add(_ obj: Action) throws {
        actions[obj.id] = CodableAction(obj)
        try Documents.instance?.store(actions[obj.id], as: obj.id)
        try commit()
    }
    
    override func remove(_ obj: Action) throws {
        actions.removeValue(forKey: obj.id)
        try Documents.instance?.remove(obj.id)
        try commit()
    }
}
