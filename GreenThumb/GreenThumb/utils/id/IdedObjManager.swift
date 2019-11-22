//
//  IdedObjManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/10/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class IdedObjManager<T:IdedObj>: Storable, CustomStringConvertible {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case name = "name"
        case idGenerator = "idGenerator"
        case objIds = "objIds"
    }

    var version: String
    var name: String
    var idGenerator: IdGenerator
    var ids: [UniqueId]
    var objs: [UniqueId:T]
    var log: Log? {
        return AppDelegate.current?.log
    }
    var description: String {
        return name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        let str  = try container.decode(String.self, forKey: .name)
        name = str
        idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
        ids = try container.decode([UniqueId].self, forKey: .objIds)
        objs = [:]
        log?.out(.info, "Loading \(str)")
        for id in ids {
            do {
                objs[id] = try Documents.instance?.retrieve(id, as: T.self)
                //log?.out(.info, "Loaded \(id)")
            } catch {
                AppDelegate.current?.log?.out(.error, "Unable to load and add object \(id) to \(self).")
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
    }
    
    init(_ name: String, _ idPrefix: String, _ lastId: Int = 0, objects: [T] = []) {
        version = Defaults.version
        self.name = name
        idGenerator = IdGenerator(idPrefix, lastId)
        ids = objects.map{$0.id}
        objs = [:]
        objects.forEach{objs[$0.id] = $0}
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
        try container.encode(idGenerator, forKey: .idGenerator)
        try container.encode(ids.map{$0}, forKey: .objIds)
    }
    
    func newId() -> UniqueId {
        return idGenerator.newId()
    }
    
    /*func replaceId(from: UniqueId, to: UniqueId) throws {
        if from != to {
            return
        }
        guard let pos = ids.firstIndex(of: from) else {
            throw GenericError("Unable to replace id \(from) to \(to)", specs: "Id \(from) not found.")
        }
        if let _ = objs[to] {
            throw GenericError("Object matching id \(to) found in \(name). Unable to change id for object \(to).")
        }
        var obj = objs[from]
        obj?.id = to
        ids[pos] = to
        objs[to] = obj
        objs[from] = nil
    }*/
    
    func commit() throws {
        do {
            try Documents.instance?.store(self, as: name)
        } catch {
            throw GenericError("Unable to commit changes to \(name): \(error.localizedDescription)")
        }
    }
    
    func add(_ obj: T) throws {
        do {
            try Documents.instance?.store(obj, as: obj.id)
        } catch {
            throw GenericError("Unable to store \(obj): \(error.localizedDescription)")
        }
        if objs[obj.id] == nil {
            ids.append(obj.id)
        }
        objs[obj.id] = obj
        try commit()
    }
    
    func remove(_ id: UniqueId) throws {
        if let pos = ids.firstIndex(of: id) {
            ids.remove(at: pos)
            objs.removeValue(forKey: id)
        }
        try Documents.instance?.remove(id)
        try commit()
        
    }
    
    func get(_ id: UniqueId) -> T? {
        return objs[id]
    }
    
    func objects(_ ids: [UniqueId]) -> [T] {
        return ids.compactMap{objs[$0]}
    }
}
