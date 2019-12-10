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
    var isValid: Bool {
        if version.isEmpty || name.isEmpty || ids.count != objs.count {
            return false
        }
        for id in ids {
            if let obj = objs[id] {
                if obj.isValid {
                    continue
                }
            }
            return false
        }
        return true
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        let str  = try container.decode(String.self, forKey: .name)
        name = str
        idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
        ids = try container.decode([UniqueId].self, forKey: .objIds)
        objs = [:]
        var recovered: [UniqueId] = []
        var nFail = 0
        log?.out(.info, "Loading \(str)")
        for id in ids {
            do {
                objs[id] = try Documents.instance?.retrieve(id, as: T.self)
            } catch {
                AppDelegate.current?.log?.out(.error, "Unable to load and add object \(id) to \(self).")
                if let obj = objs[id] {
                    if obj.isValid {
                        recovered.append(obj.name)
                    }
                    else {
                        objs.removeValue(forKey: id)
                    }
                    continue
                }
                ids.remove(at: ids.firstIndex(of: id)!)
                nFail += 1
            }
        }
        var errMsg = ""
        if !recovered.isEmpty {
            errMsg += " [\(recovered.joined(separator: ", "))] recovered with defaults. "
        }
        if nFail != 0 {
            errMsg += " Unable to recover \(nFail)."
        }
        if !errMsg.isEmpty {
            throw GenericError("Error loading objects to \(self).\(errMsg)")
        }
    }
    
    init(_ name: String, _ idGenerator: IdGenerator) {
        version = Defaults.version
        self.name = name
        self.idGenerator = idGenerator
        ids = []
        objs = [:]
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
