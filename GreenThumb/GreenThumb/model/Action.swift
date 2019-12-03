//
//  Action.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol ActionType: Storable {
    var name: String {get}
}

protocol Action: Storable, CustomStringConvertible {
    var version: String {get}
    var name: String {get set}
    var description: String {get}
    var category: ActionCategory {get}
    var type: ActionType {get}
}

extension Action {
    var description: String {
        return name
    }
    var category: ActionCategory {
        fatalError("Needs override.")
    }
    var type: ActionType {
        fatalError("Needs override.")
    }
    
    static func ==(_ lhs: Action, _ rhs: Action) -> Bool {
        return lhs.description == rhs.description
    }
}
