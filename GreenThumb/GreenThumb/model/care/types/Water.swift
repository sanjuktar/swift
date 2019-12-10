//
//  Water.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Water: Action {
    enum Quantity: Storable, CustomStringConvertible {
        case soak
        case light
        //case volume(Volume)
        
        static var volumePrefix = "water with "
        var version: String {
            return Defaults.version
        }
        var name: String {
            return description
        }
        var description: String {
            switch self {
            case .soak:
                return "soak"
            case .light:
                return "water lightly"
            //case .volume(let v):
            //    return "\(Quantity.volumePrefix)\(v)"
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            switch str {
            case Quantity.soak.description:
                self = .soak
            case Quantity.light.description:
                self = .light
            default:
                /*if str.hasPrefix(Quantity.volumePrefix) {
                    let indx = str.index(str.startIndex, offsetBy: str.count, limitedBy: str.endIndex)
                    if indx != str.endIndex {
                        self = .volume(Volume(from: String(str.suffix(from: indx!))))
                        break
                    }
                }*/
                throw GenericError("Unable to decode Water action \"\(str)\"")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(description)
        }
    }
    
    var version: String
    var name: String
    var quantity: Quantity = .soak
    var type: ActionType {
        return CareType.water
    }
    var description: String {
        return quantity.description
    }
    
    init(name: String = "", _ quantity: Quantity) {
        self.version = Defaults.version
        self.name = name
        self.quantity = quantity
    }
}
