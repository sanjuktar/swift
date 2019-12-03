//
//  Fertilize.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Fertilize: Action {
    var version: String
    var name: String
    var fertilizer: String = "unknown"
    var quantity: Volume = .any
    var type: ActionType {
        return CareType.fertilize
    }
    var description: String {
        return "\(quantity) of \(fertilizer)"
    }
    
    enum FertilizeKeys: String, CodingKey {
        case fertilizer
        case quantity
    }
    
   /* required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: FertilizeKeys.self)
        fertilizer = try container.decode(String.self, forKey: .fertilizer)
        quantity = try container.decode(Volume.self, forKey: .quantity)
    }*/
    
    init(name: String = "", _ fertilizer: String, _ quantity: Volume, notes: String = "") {
        version = Defaults.version
        self.name = name
        self.fertilizer = fertilizer
        self.quantity = quantity
    }
    
    /*override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: FertilizeKeys.self)
        try container.encode(fertilizer, forKey: .fertilizer)
        try container.encode(quantity, forKey: .quantity)
    }*/
}
