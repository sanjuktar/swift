//
//  CareActions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Move: Action {
    override var description: String {
        return "move"
    }
    override var type: ActionType {
        return CareType.move
    }
}

class PestControl: Action {
    override var description: String {
        return "pest control"
    }
    override var type: ActionType {
        return CareType.pestControl
    }
}

class Pruning: Action {
    override var description: String {
        return "prune"
    }
    override var type: ActionType {
        return CareType.prune
    }
}
