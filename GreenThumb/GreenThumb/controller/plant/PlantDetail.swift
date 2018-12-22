//
//  PlantDataItem.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/16/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation


enum PlantDetail: String {
    enum Section: String {
        case names = "Names"
        case care = "Care Schedule"
        case noSection = ""
        
        static var cases: [Section] = [.names, .care]
        static var nSections: Int {
            return cases.count
        }
    }
    
    case location = "Location"
    // Names
    case preferedName = "Prefered"
    case nickname = "Nickname"
    case commonName = "Common"
    case scientificName = "Scientific"
    // Care
    case water = "Water"
    case sun = "Sun exposure"
    case fertilize = "Fertilizer"
    case pestControl = "Pest Control"
    case pruning = "Pruning"
    case repot = "Repot"
    
    static var items: [Section:[PlantDataItem]] =
        [.noSection:[.location],
         .names:[.nickname, .commonName, .scientificName],
         .care:[.water, .fertilize, .pestControl, .sun]]
    var section: Section {
        for section in PlantDataItem.Section.cases {
            for item in PlantDataItem.items[section]! {
                if item == self {
                    return section
                }
            }
        }
        return .noSection
    }
    
    func data(for plant: Plant) -> String {
        switch self {
        case .preferedName:
            return plant.preferedNameType.rawValue
        case .nickname:
            return plant.names[Plant.NameType.nickname] ?? ""
        case .commonName:
            return plant.names[Plant.NameType.common] ?? ""
        case .scientificName:
            return plant.names[Plant.NameType.scientific] ?? ""
        case .location:
            return plant.location.name
        case .water:
            return plant.care.current(.water)
        case .sun:
            return plant.care.current(.sun)
        case .fertilize:
            return plant.care.current(.fertilize)
        case .pestControl:
            return plant.care.current(.pestControl)
        case .pruning:
            return plant.care.current(.pruning)
        case .repot:
            return plant.care.current(.repot)
        }
    }
}
