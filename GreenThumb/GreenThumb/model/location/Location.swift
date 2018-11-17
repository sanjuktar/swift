//
//  Location.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Location: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case plants
    }
    
    var name: String
    var plants: Set<Plant>
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        plants = try container.decode(Set<Plant>.self, forKey: .plants)
    }
    
    init(_ name: String, plants: Set<Plant> = []) {
        self.name = name
        self.plants = plants
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(plants.map{$0}, forKey: .plants)
    }
    
    func add(_ plant: Plant) {
        plants.insert(plant)
    }
    
    func remove(_ plant: Plant) {
        plants.remove(plant)
    }
    
    func found(_ plant: Plant) -> Bool {
        return plants.contains(plant)
    }
}
