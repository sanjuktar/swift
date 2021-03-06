//
//  Location.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class Location: IdedObj, CustomStringConvertible {
    
    enum CodingKeys: String, CodingKey {
        case version
        case id
        case name
        case image
        case conditionsUsed
        case conditions
    }
    
    static var manager: Location.Manager?
    var version: String
    var id: UniqueId
    var name: String
    var image: UIImage?
    var conditions: AnnualConditions
    var conditionsUsed: [ConditionsType]
    var description: String {
        return name
    }
    var isValid: Bool {
        return LocationDetail.validate(self)
    }
    var plants: [UniqueId] {
        return Plant.manager?.plants(at: id) ?? []
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let data = try container.decode(Data?.self, forKey: .image)
        image = data == nil ? nil : UIImage(data: data!)
        conditionsUsed = try container.decode([ConditionsType].self, forKey: .conditionsUsed)
        conditions = try container.decode(AnnualConditions.self, forKey: .conditions)
    }
    
    init(_ name: String, conditions:AnnualConditions? = nil) {
        version = Defaults.version
        self.id = (Location.manager?.newId())!
        self.name = name
        self.image = nil
        if conditions != nil {
            self.conditions = conditions!
            conditionsUsed = ((conditions?.isOutdoors ?? false) ? ConditionsType.outdoorTypes : ConditionsType.indoorTypes)
        }
        else {
            conditionsUsed = ConditionsType.indoorTypes
            self.conditions = AnnualConditions()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(image?.imageData, forKey: .image)
        try container.encode(conditionsUsed, forKey: .conditionsUsed)
        try container.encode(conditions, forKey: .conditions)
    }
    
    func clone() -> Location {
        let obj = Location(name, conditions: conditions)
        obj.id = id
        return obj
    }
    
    func persist() throws {
        try Location.manager?.add(self)
    }
    
    func unpersist() throws {
        try Location.manager?.remove(id)
    }
    
    func updateDetailsUsed(_ isOutside: Bool) {
        conditionsUsed = (isOutside ? ConditionsType.outdoorTypes : ConditionsType.indoorTypes)
    }
}
