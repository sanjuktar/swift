//
//  ProvidedIds.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/9/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class ProvidedIds: IdGenerator {
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    init(_ prefix: String) {
        super.init(prefix, 0)
    }
    
    override func newId(_ extraInfo: String = "") -> UniqueId {
        return "\(prefix)\(extraInfo)"
    }
}
