//
//  Quantity.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

protocol Quantity {
    var desc: String {get set}
}

enum Volume: Quantity {
    case ml(Int)
    case oz(Int)
    case drops(Int)
    case tbsp(Double)
    case custom(Int, String)
    
    var desc: String {
        switch self {
        case .ml(let n):
            return "\(n)ml"
        case .oz(let n):
            return "\(n)oz"
        case .drops(let n):
            return "\(n) drops"
        case .tbsp(let n):
            return "\(n) tbsp"
        case .custom(let str):
            return "\(str)"
        }
    }
}
