//
//  Location.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

extension Location {
    class Manager: IdedObjManager<Location> {
        enum CodingKeys: String, CodingKey {
            case name
            case locations
            case idGenerator
        }
        
        static var defaultName: String = "Location.Manager"
        var locations: [Location] = []
        var log: Log? = AppDelegate.current?.log
        
        static func load(name :String = defaultName) throws -> Manager {
            return try (Documents.instance?.retrieve(name, as: Manager.self))!
        }
        
        required init(from decoder: Decoder)  throws {
            try super.init(from: decoder)
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
            let locIds = try container.decode([UniqueId].self, forKey: .locations)
            try locIds.forEach{id in
                let loc = try Documents.instance?.retrieve(id, as: Location.self)
                locations.append(loc!)
            }
        }
        
        init(_ name: String = Manager.defaultName, _ locations: [Location] = []) {
            super.init(name, "Location")
            self.locations = locations
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(locations, forKey: .locations)
            try container.encode(idGenerator, forKey: .idGenerator)
        }
        
        override func commit() throws {
            try Documents.instance?.store(self, as: name)
        }
        
        func get(_ name: String) -> Location? {
            return locations.first{$0.name == name}
        }
        
        override func add(_ obj: Location) throws {
            if let indx = locations.firstIndex(of: obj) {
                locations.remove(at: indx)
            }
            self.locations.append(obj)
            try Documents.instance?.store(obj, as: obj.id)
            try commit()
        }
        
        override func remove(_ obj: Location) throws {
            if let pos = locations.firstIndex(of: obj) {
                locations.remove(at: pos)
            }
            try Documents.instance?.remove(obj.id)
            try commit()
        }
    }
}
