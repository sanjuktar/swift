//
//  CareActions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Move: Action {
    init(_ desc: String) {
        super.init()
        self.desc = desc
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class PestControl: Action {
    init(_ desc: String) {
        super.init()
        self.desc = desc
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class Pruning: Action {
    init(_ desc: String) {
        super.init()
        self.desc = desc
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
