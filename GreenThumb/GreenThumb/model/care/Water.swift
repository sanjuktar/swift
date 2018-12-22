//
//  Water.swift
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
