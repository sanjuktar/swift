//
//  LocationsManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/9/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocationsManager: Codable {
    static var current: LocationsManager? {
        return (UIApplication.shared.delegate as! AppDelegate).locations
    }
    static var locationUnknown = "Location Unknown"
    static var unknownLocation = Location(LocationsManager.locationUnknown)
    var locations: [String: Location]
    var defaut: String = LocationsManager.locationUnknown
    static var name: String = "LocationManager"
    var allPlants: [Plant] {
        get {
            var plants: [Plant] = []
            for loc in locations.values {
                plants.append(contentsOf: loc.plants)
            }
            return plants
        }
    }
    
    static func load() throws -> LocationsManager {
        return try (Documents.instance?.retrieve(name, as: LocationsManager.self))!
    }
    
    init() {
        locations = [LocationsManager.locationUnknown: LocationsManager.unknownLocation]
    }
    
    func commit() throws {
        try Documents.instance?.store(self, as: LocationsManager.name)
    }
    
    func add(_ location: Location) {
        locations[location.name] = location
    }
    
    func add(_ plant: Plant, at loc: String) {
        locations[loc]?.plants.insert(plant)
        let current = locate(plant)
        if current != nil && current != loc {
            move(plant, to: loc)
        }
        else {
            locations[loc]?.plants.insert(plant)
        }
    }
    
    func move(_ plant: Plant, to loc: String) {
        guard let currentLoc = locate(plant) else {return}
        locations[loc]?.plants.insert(plant)
        locations[currentLoc]?.remove(plant)
    }
    
    func remove(_ plant: Plant) {
        guard let loc = locate(plant) else {return}
        locations[loc]!.remove(plant)
    }
    
    func locate(_ plant: Plant) -> String? {
        for loc in locations.values {
            if loc.found(plant) {
                return loc.name
            }
        }
        return nil
    }
}
