//
//  CareInstructions.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/9/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

extension CareInstructions {
    class Manager: IdedObjManager<CareInstructions> {
        enum CodingKeys: String, CodingKey {
            case name
            case instructions
            case idGenerator
        }
        
        static var defaultName: String = "Care.Manager"
        var instructions: [CareInstructions] = []
        var log = AppDelegate.current?.log
        
        static func load(name: String = defaultName) throws -> CareInstructions.Manager {
            return try (Documents.instance?.retrieve(name, as: CareInstructions.Manager.self))!
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            instructions = try container.decode([CareInstructions].self, forKey: .instructions)
            idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
        }
        
        init(_ name: String = Manager.defaultName, instructions: [CareInstructions] = [], lastId: Int = 0) {
            super.init(name, "CareInstructions")
            self.instructions = instructions
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(instructions.map{$0.id}, forKey: .instructions)
            try container.encode(idGenerator, forKey: .idGenerator)
        }
        
        override func commit() throws {
            try Documents.instance?.store(self, as: name)
        }
        
        override func add(_ obj: CareInstructions) throws {
            instructions.append(obj)
            try commit()
        }
        
        override func remove(_ obj: CareInstructions) throws {
            instructions.remove(at: instructions.index(of: obj)!)
            try commit()
        }
        
    }
}
