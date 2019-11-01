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
        case noHeading = ""
        case names = "Names"
        case care = "Care Schedule"
        
        static var cases: [Section] = [.noHeading, .names, .care]
        static var nSections: Int {
            return cases.count
        }
    }
    
    case ignore = "ignore"
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
        [.noHeading:[.location],
         .names:[.nickname, .commonName, .scientificName],
         .care:CareType.inUseList.map{PlantDetail($0)}] 
    var section: Section {
        for section in PlantDetail.Section.cases {
            for item in PlantDetail.items[section]! {
                if item == self {
                    return section
                }
            }
        }
        return .noHeading
    }
    var isName: Bool {
        return PlantDetail.items[.names]?.firstIndex(of: self) != nil
    }
    var isCare: Bool {
        return PlantDetail.items[.care]?.firstIndex(of: self) != nil
    }
    
    init(_ type: CareType) {
        switch type {
        case .water:
            self = PlantDetail.water
        case .fertilize:
            self = PlantDetail.fertilize
        case .light:
            self = PlantDetail.light
        case .prune:
            self = PlantDetail.prune
        case .pestControl:
            self = PlantDetail.pestControl
        default:
            self = PlantDetail.ignore
        }
    }
    
    func data(for plant: Plant) -> String {
        switch self {
        case .ignore:
            fatalError("Invalid detail!!!!!")
        case .nickname:
            return plant.names[Plant.NameType.nickname] ?? ""
        case .commonName:
            return plant.names[Plant.NameType.common] ?? ""
        case .scientificName:
            return plant.names[Plant.NameType.scientific] ?? ""
        case .location:
            return Location.manager!.get(plant.location)!.name
        case .water:
            return CareDetail.water.data(plant.care)
        case .light:
            return CareDetail.light.data(plant.care)
        case .fertilize:
            return CareDetail.fertilize.data(plant.care)
        case .pestControl:
            return CareDetail.pestControl.data(plant.care)
        case .prune:
            return CareDetail.prune.data(plant.care)
        case .repot:
            return CareDetail.repot.data(plant.care)
        }
    }
}
