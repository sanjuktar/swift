//
//  ActionManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/9/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class ActionManager: IdedObjManager<Action> {
    static var defaultName = "Action.Manager"
    
    static func load(name: String = defaultName) throws -> ActionManager {
        return try (Documents.instance?.retrieve(name, as: ActionManager.self))!
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    init(_ name: String = ActionManager.defaultName) {
        super.init(name, "Action")
    }
}
