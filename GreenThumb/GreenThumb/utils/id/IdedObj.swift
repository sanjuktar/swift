//
//  IdedObj.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/10/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

typealias UniqueId = String

protocol IdedObj: Storable, Hashable, CustomStringConvertible {
    var version: String {get}
    var id: UniqueId {get set}
    var description: String {get}

    func persist() throws
    func unpersist() throws
    func updatePersisted() throws
}

extension IdedObj {
    var name: String {
        return id
    }
    
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func updatePersisted() throws {
        try Documents.instance?.remove(id)
        try Documents.instance?.store(self, as: id)
    }
}
