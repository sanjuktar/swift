//
//  CareAction.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum Water: Action {
    case nodesc
    case soak
    case lightly
    case ml(Int)
    case oz(Int)
    case custom(String)
    
    var desc: String {
        var str: String
        switch self {
        case .soak:
            str = " thoroughly"
        case .lightly:
            str = " lightly"
        case .ml(let qnty):
            str = " with \(qnty)ml"
        case .oz(let qnty):
            str = " with \(qnty)oz"
        case .custom(let s):
            str = s
        default:
            str = ""
        }
        return str
    }
}

class Fertilize: Action {
    var name: String
    var qnty: Quantity
    var desc: String {
        return "\(qnty.desc) of \(name)"
    }
    
    init(_ name: String, _ qnty: Quantity) {
        self.name = name
        self.qnty = qnty
    }
}

enum SunExposure: String, Action {
    case any = "any"
    case fullSun = "full sun"
    case someSun = "some sun"
    case noAfternoonSun = "no afternoon sun"
    case bright = "bright light"
    case indirectSun = "indirect sun"
    case lowLight = "low light"
    
    var desc: String {
        return self.rawValue
    }
}

class PestControl: Action {
    var desc: String
    
    init(_ desc: String) {
        self.desc = desc
    }
}

class Pruning: Action {
    var desc: String
    
    init(_ desc: String) {
        self.desc = desc
    }
}
