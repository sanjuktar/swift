//
//  SunExposure.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Sun: Action {
    enum Exposure: String, Codable {
        case any = "any"
        case fullSun = "full sun"
        case someSun = "some sun"
        case noAfternoonSun = "no afternoon sun"
        case bright = "bright light"
        case indirectSun = "indirect sun"
        case lowLight = "low light"
    }
    
    enum SunKey: String, CodingKey {
        case quantity
    }
    
    var quantity: Exposure = .any
    override var desc: String {
        get {
            return quantity.rawValue
        }
        set {}
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        quantity = try decoder.container(keyedBy: SunKey.self).decode(Exposure.self, forKey: .quantity)
    }
    
    init(_ quantity: Exposure = .any) {
        super.init()
        self.quantity = quantity
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: SunKey.self)
        try container.encode(quantity, forKey: .quantity)
    }
}
