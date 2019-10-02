//
//  PlantDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/16/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

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
    case light = "Light"
    case fertilize = "Fertilizer"
    case pestControl = "Pest Control"
    case prune = "Pruning"
    case repot = "Repot"
    
    static var items: [Section:[PlantDetail]] =
        [.noSection:[.location],
         .names:[.nickname, .commonName, .scientificName],
         .care:[.water, .fertilize, .pestControl, .light]]
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
        return PlantDetail.items[.names]?.firstIndex(of: self) != nil
    }
    var isCare: Bool {
        return PlantDetail.items[.care]?.firstIndex(of: self) != nil
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
            return plant.care.current(.water).description
        case .light:
            return plant.care.current(.light).description
        case .fertilize:
            return plant.care.current(.fertilize).description
        case .pestControl:
            return plant.care.current(.pestControl).description
        case .prune:
            return plant.care.current(.prune).description
        case .repot:
            return "" 
        }
    }
}
