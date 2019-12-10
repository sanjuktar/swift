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
        case care
        case image
    }
    
    static var manager :Manager? 
    var version: String
    var id: UniqueId
    var names: NameList
    var location: UniqueId
    var care: CareInstructions
    var image: UIImage?
    var name: String {
        return names.use
    }
    var description: String {
        return name
    }
    var isValid: Bool {
        return PlantDetail.validate(self)
    }
    var clone: Plant {
        return Plant(self)
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
        care = try container.decode(CareInstructions.self, forKey: .care)
        if care.schedule.isEmpty {
            care.schedule = Defaults.care!
            AppDelegate.current?.log?.out(.error, "Unable to load care schedule for \(name). Using defaults.")
            do {
                try persist()
            } catch {
                AppDelegate.current?.log?.out(.error, "Unable to save \(name) with new default care schedule.")
            }
        }
        let data = try container.decode(Data?.self, forKey: .image)
        image = Plant.image(from: data)
    }
    
    init(_ names: NameList = NameList(), location: UniqueId = Defaults.location,
         image: UIImage? = nil, care: CareInstructions = CareInstructions(),
         preferedNameType: NameType = .nickname) {
        version = Defaults.version
        id = (Plant.manager?.newId())!
        self.names = names
        self.location = location
        self.image = image
        self.care = care
        //care.name = names.use
    }
    
    private init(_ plant: Plant) {
        version = plant.version
        id = plant.id
        names = plant.names
        location = plant.location
        image = plant.image
        care = plant.care
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(names, forKey: .names)
        try container.encode(location, forKey: .location)
        try container.encode(image?.imageData, forKey: .image)
        try container.encode(care, forKey: .care)
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
