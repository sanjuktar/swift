//
//  Light.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Light: Action {
    enum LightKey: String, CodingKey {
        case quantity
    }
    
    var quantity: LightExposure?
    override var desc: String {
        get {
            return quantity!.name
        }
        set {}
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        quantity = try decoder.container(keyedBy: LightKey.self).decode(LightExposure.self, forKey: .quantity)
    }
    
    init(_ quantity: LightExposure = LightExposure()) {
        super.init()
        self.quantity = quantity
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: LightKey.self)
        try container.encode(quantity, forKey: .quantity)
    }
}
