//
//  NoAction.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/3/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class NoAction: Action {
    class Typ: ActionType, Storable {
        static var name: String {
            return "noAction"
        }
        var name: String {
            return Typ.name
        }
        var version: String {
            return Defaults.version
        }
    }
    
    var version: String {
        return Defaults.version
    }
    var name: String {
        get {
            return NoAction.Typ.name
        }
        set {
        }
    }
    var description: String {
        return "no action to be performed"
    }
    var category: ActionCategory {
        return .none
    }
    var type: ActionType {
        return Typ()
    }
    
   /* required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }*/
}
