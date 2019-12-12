//
//  Plant.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class Plant: IdedObj {
    enum CodingKeys: String, CodingKey {
        case version
        case id
        case names
        case location
        case preferences
        case image
    }
    
    static var manager :Manager? 
    var version: String
    var id: UniqueId
    var names: NameList
    var location: UniqueId
    var preferences: UniqueId
    var image: UIImage?
    var name: String {
        return names.use
    }
    var description: String {
        return name
    }
    var care: CareInstructions? {
        return prefObj?.care
    }
    var preferedConditions: SeasonalConditions? {
        return prefObj?.prefered
    }
    var avoidConditions: SeasonalConditions? {
        return prefObj?.avoid
    }
    var isValid: Bool {
        return PlantDetail.validate(self)
    }
    var clone: Plant {
        return Plant(self)
    }
    private var prefObj: Preferences? {
        return Preferences.manager?.get(preferences)
    }
    
    required init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        id = try container.decode(String.self, forKey: .id)
        names = try container.decode(NameList.self, forKey: .names)
        location = try container.decode(UniqueId.self, forKey: .location)
        if Plant.manager?.get(location) == nil {
            location = Defaults.location
        }
        preferences = try container.decode(UniqueId.self, forKey: .preferences)
        let data = try container.decode(Data?.self, forKey: .image)
        image = Plant.image(from: data)
    }
    
    init(_ names: NameList = NameList(),
         location: UniqueId = Defaults.location,
         image: UIImage? = nil,
         preferences: UniqueId = Preferences.manager!.defaults[.none]!,
         preferedNameType: NameType = .nickname) {
        version = Defaults.version
        id = (Plant.manager?.newId())!
        self.names = names
        self.location = location
        self.image = image
        self.preferences = preferences
    }
    
    private init(_ plant: Plant) {
        version = plant.version
        id = plant.id
        names = plant.names
        location = plant.location
        image = plant.image
        preferences = plant.preferences
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(names, forKey: .names)
        try container.encode(location, forKey: .location)
        try container.encode(image?.imageData, forKey: .image)
        try container.encode(preferences, forKey: .preferences)
    }
    
    func persist() throws {
        try Plant.manager?.add(self)
    }
    
    func unpersist() throws {
        try Plant.manager?.remove(id)
    }
    
    private static func image(from data: Data?) -> UIImage? {
        return data == nil ? nil : UIImage(data: data!)
    }
}
