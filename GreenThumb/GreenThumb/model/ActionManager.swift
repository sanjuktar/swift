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
    var actions: [Action] = []
    var log: Log? = AppDelegate.current?.log
        
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        actions = try container.decode([CodableAction].self, forKey: .actions).map{$0.action}
        idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
    }
    
    init(_ name: String = ActionManager.defaultName, lastId: Int = 0) {
        super.init(name, "Action")
        self.actions = []
    }
    
    override func encode(to encoder: Encoder) throws {
        var arr = [CodableAction]()
        for action in actions {
            arr.append(CodableAction(action))
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(arr, forKey: .actions)
        try container.encode(idGenerator, forKey: .idGenerator)
    }
    
    static func load(name: String = defaultName) throws -> ActionManager {
        return try (Documents.instance?.retrieve(name, as: ActionManager.self))!
    }
    
    override func commit() throws {
        try Documents.instance?.store(self, as: name)
    }
    
    override func add(_ obj: Action) throws {
        actions.append(obj)
        try commit()
    }
    
    override func remove(_ obj: Action) throws {
        actions.remove(at: actions.firstIndex(of: obj)!)
        try commit()
    }
}
