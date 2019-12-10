//
//  Light.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Light: Action {
    var quantity: LightExposure?
    var version: String
    var name: String
    var type: ActionType {
        return CareType.light
    }
    var description: String {
        return quantity!.name
    }
    
    init(name: String = "", _ quantity: LightExposure = LightExposure()) {
        version = Defaults.version
        self.name = name
        self.quantity = quantity
    }
}
