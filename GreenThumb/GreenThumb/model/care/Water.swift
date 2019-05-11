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
    override var desc: String {
        get {
            var str: String
            switch quantity {
            case .custom(_):
                str = quantity.desc
            default:
                str = "Water with \(quantity.desc)"
            }
            return str
        }
        set {}
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
        var container = encoder.container(keyedBy: WaterKeys.self)
        try container.encode(quantity, forKey: .quantity)
    }
}