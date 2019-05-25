//
//  PlantDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/16/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation


enum PlantDetail: String, Codable {
    enum Section: String, CaseIterable {
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
    case nickname = "Nickname"
    case commonName = "Common"
    case scientificName = "Scientific"
    // Care
    case water = "Water"
    case sun = "Sun exposure"
    case fertilize = "Fertilizer"
    case pestControl = "Pest Control"
    case prune = "Pruning"
    case repot = "Repot"
    
    static var items: [Section:[PlantDetail]] =
        [.noSection:[.location],
         .names:[.nickname, .commonName, .scientificName],
         .care:[.water, .fertilize, .pestControl, .sun]]
    var section: Section {
        for section in PlantDetail.Section.cases {
            for item in PlantDetail.items[section]! {
                if item == self {
                    return section
                }
            }
        }
        return .noSection
    }
    var isName: Bool {
        switch self {
        case .nickname:
            return true
        case .commonName:
            return true
        case .scientificName:
            return true
        default:
            return false
        }
    }
    
    func data(for plant: Plant) -> String {
        switch self {
        case .nickname:
            return plant.names[Plant.NameType.nickname] ?? ""
        case .commonName:
            return plant.names[Plant.NameType.common] ?? ""
        case .scientificName:
            return plant.names[Plant.NameType.scientific] ?? ""
        case .location:
            return Location.manager!.get(plant.location)!.name
        case .water:
            return CareDetail.water(plant.care.currentSeason(.water).id).data(plant.care)
        case .sun:
            return CareDetail.sun(plant.care.currentSeason(.light).id).data(plant.care)
        case .fertilize:
            return CareDetail.fertilize(plant.care.currentSeason(.fertilize).id).data(plant.care)
        case .pestControl:
            return CareDetail.pestControl(plant.care.currentSeason(.pestControl).id).data(plant.care)
        case .prune:
            return CareDetail.prune.data(plant.care)
        case .repot:
            return CareDetail.repot.data(plant.care)
        }
    }
}
