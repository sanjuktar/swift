//
//  Water.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Water: Action {
    enum WaterKeys: String, CodingKey {
        case quantity
    }
    
    static var soak: Volume = .custom("Soak")
    static var light: Volume = .custom("Water lightly")
    var quantity: Volume = .any
    override var description: String {
        var str: String
        switch quantity {
        case .custom(_):
            str = quantity.description
        default:
            str = "Water with \(quantity)"
        }
        return str
    }
    
    required init(from decoder: Decoder) throws {
        quantity = try decoder.container(keyedBy: WaterKeys.self).decode(Volume.self, forKey: .quantity)
        try super.init(from: decoder)
    }
    
    init(_ quantity: Volume) {
        super.init()
        self.quantity = quantity
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: WaterKeys.self)
        try container.encode(quantity, forKey: .quantity)
    }
}
