//
//  IdGenerator.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class IdGenerator: Codable {
    var prefix: String
    var currentId: Int
    
    init(_ prefix: String, _ startId: Int = 0) {
        self.prefix = prefix
        self.currentId = startId
    }
    
    func newId(_ extraInfo: String = "") -> UniqueId {
        currentId += 1
        return "\(prefix)\(extraInfo)\(currentId-1)"
    }
}
