//
//  PlantDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/16/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation


enum PlantDetail: String, Codable {
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
    //case preferedName = "Prefered"
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
    
    /*func careDetail(_ instructions: CareInstructions) -> CareDetail? {
        switch self {
        case .water:
            return CareDetail.water(instructions.currentSeason(.water))
        case .sun:
            return CareDetail.sun(instructions.currentSeason(.sun))
        case .fertilize:
            return CareDetail.fertilize(instructions.currentSeason(.fertilize))
        case .pestControl:
            return CareDetail.pestControl(instructions.currentSeason(.pestControl))
        case .prune:
            return CareDetail.prune
        case .repot:
            return CareDetail.repot
        default:
            return nil
        }
    }*/
    
    func data(for plant: Plant) -> String {
        switch self {
        case .nickname:
            return plant.names[Plant.NameType.nickname] ?? ""
        case .commonName:
            return plant.names[Plant.NameType.common] ?? ""
        case .scientificName:
            return plant.names[Plant.NameType.scientific] ?? ""
        case .location:
            return plant.location.name 
        case .water:
            return CareDetail.water(plant.care.currentSeason(.water)).data(plant.care)
                //(plant.care.detail(.water)?.data(plant.care))!
        case .sun:
            return CareDetail.sun(plant.care.currentSeason(.sun)).data(plant.care)     //plant.care.detail(.sun)!.data(plant.care)
        case .fertilize:
            return CareDetail.fertilize(plant.care.currentSeason(.fertilize)).data(plant.care)
                //plant.care.detail(.fertilize)!.data(plant.care)
        case .pestControl:
            return CareDetail.pestControl(plant.care.currentSeason(.pestControl)).data(plant.care)
        //plant.care.detail(.pestControl)!.data(plant.care)
        case .prune:
            return CareDetail.prune.data(plant.care)
                //plant.care.detail(.prune)!.data(plant.care)
        case .repot:
            return CareDetail.repot.data(plant.care)
            //return plant.care.detail(.repot)!.data(plant.care)
        }
    }
}
