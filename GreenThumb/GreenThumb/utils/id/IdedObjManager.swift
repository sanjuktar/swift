//
//  IdedObjManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/10/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class IdedObjManager<T:IdedObj>: Codable {
    var name: String
    var idGenerator: IdGenerator
    
    init(_ name: String, _ idPrefix: String, _ lastId: Int = 0) {
        self.name = name
        idGenerator = IdGenerator(idPrefix, lastId)
    }
    
    func newId() -> UniqueId {
        return idGenerator.newId()
    }
    
    func commit() throws {}
    func add(_ obj: T) throws {}
    func remove(_ obj: T) throws {}
}
