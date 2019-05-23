//
//  UnknownLocation.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class UnknownLocation: Location {
    static var defaultName = "Location unknown"
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    init(_ inOrOut: InOrOut = InOrOut(.indoors)) {
        super.init(UnknownLocation.defaultName)
        conditions.addValue(.inOrOut, season: Season.allYear.id, value: inOrOut)
    }
}
