//
//  CareActions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Move: Action {
    var version: String
    var name: String
    var description: String {
        return "move"
    }
    var type: ActionType {
        return CareType.move
    }
    
    init(_ name: String = "") {
        version = Defaults.version
        self.name = name
    }
}

class PestControl: Action {
    var version: String
    var name: String
    var description: String {
        return "pest control"
    }
    var type: ActionType {
        return CareType.pestControl
    }
    
    init(_ name: String = "") {
        version = Defaults.version
        self.name = name
    }
}

class Pruning: Action {
    var version: String
    var name: String
    var description: String {
        return "prune"
    }
    var type: ActionType {
        return CareType.prune
    }
    
    init(_ name: String = "") {
        version = Defaults.version
        self.name = name
    }
}
