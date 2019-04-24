//
//  Plant.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

extension Plant {
    class Manager: IdedObjManager<Plant> {
        enum CodingKeys: String, CodingKey {
            case name
            case plants
            case idGenerator
            case preferedNameType
        }
        
        static var defaultName = "Plant.manager"
        var plants: [Plant] = []
        var preferedNameType: Plant.NameType = .nickname
        var log :Log? = AppDelegate.current?.log
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            let plantIds = try container.decode([UniqueId].self, forKey: .plants)
            print("Loading plant ids: \(plantIds)")
            plants = []
            for id in plantIds {
                let plant = try Documents.instance?.retrieve(id, as: Plant.self)
                plants.append(plant!)
            }
            idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
            preferedNameType = try container.decode(Plant.NameType.self, forKey: .preferedNameType)
        }
        
        init(_ name: String = Manager.defaultName, _ plants: [Plant] = [], _ lastId: Int = 0, _ preferedNameType: Plant.NameType = Plant.NameType.nickname) {
            super.init(name, "Plant")
            self.plants = plants
            self.preferedNameType = preferedNameType
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(plants.map{$0.id}, forKey: .plants)
            print("Storing plant ids: \(plants.map{$0.id})")
            try container.encode(idGenerator, forKey: .idGenerator)
            try container.encode(preferedNameType, forKey: .preferedNameType)
        }
        
        static func load(name: String = defaultName) throws -> Plant.Manager {
            return try (Documents.instance?.retrieve(name, as: Plant.Manager.self))!
        }
        
        override func commit() throws {
            try Documents.instance?.store(self, as: name)
        }
        
        override func add(_ obj: Plant) throws {
            plants.append(obj)
            try Documents.instance!.store(obj, as: obj.id)
            try commit()
        }
        
        override func remove(_ obj: Plant) throws {
            plants.remove(at: plants.firstIndex(of: obj)!)
            try Documents.instance?.remove(obj.id)
            try commit()
        }
    }
}
