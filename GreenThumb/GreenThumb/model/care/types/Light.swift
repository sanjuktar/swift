//
//  Light.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Light: Action {
    /*enum LightKey: String, CodingKey {
        case quantity
    }*/
    
    var quantity: LightExposure?
    var version: String
    var name: String
    var type: ActionType {
        return CareType.light
    }
    var description: String {
        return quantity!.name
    }
    
    /*required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        quantity = try decoder.container(keyedBy: LightKey.self).decode(LightExposure.self, forKey: .quantity)
    }*/
    
    init(name: String = "", _ quantity: LightExposure = LightExposure()) {
        version = Defaults.version
        self.name = name
        self.quantity = quantity
    }
    
    /*override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: LightKey.self)
        try container.encode(quantity, forKey: .quantity)
    }*/
}
