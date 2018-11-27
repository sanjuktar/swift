//
//  PlantDataItem.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/16/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum PlantDataItem: String {
    case preferedName = "Prefered name"
    case nickname = "Nickname"
    case commonName = "Common name"
    case scientificName = "Scientific name"
    
    static var cases: [PlantDataItem] = [.nickname, .commonName, .scientificName]
    var row: Int {
        return PlantDataItem.cases.index(of: self)!
    }
    
    func data(for plant: Plant) -> String {
        switch self {
        case .preferedName:
            return plant.name
        case .nickname:
            return plant.names[Plant.NameType.nickname] ?? ""
        case .commonName:
            return plant.names[Plant.NameType.common] ?? ""
        case .scientificName:
            return plant.names[Plant.NameType.scientific] ?? ""
        }
    }
}
