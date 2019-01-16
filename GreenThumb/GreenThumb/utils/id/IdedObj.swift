//
//  IdedObj.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/10/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

typealias UniqueId = String

protocol IdedObj: Codable, Hashable {
    var id: UniqueId {get}
    func persist() throws
    func unpersist() throws
    func updatePersisted() throws
}

extension IdedObj {
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    func updatePersisted() throws {
        try Documents.instance?.remove(id)
        try Documents.instance?.store(self, as: id)
    }
}
