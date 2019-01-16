//
//  CareInstructions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class CareInstructions: IdedObj {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case seasonal
        case nonSeasonal
        case notes
    }
    static var manager: Manager? {
        return AppDelegate.current?.care
    }
    var id: UniqueId
    var name: String
    var seasonal: [PlantDetail:SeasonalSchedule]
    var nonSeasonal: [PlantDetail:Timetable]
    var notes: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        seasonal = try container.decode([PlantDetail:SeasonalSchedule].self, forKey: .seasonal)
        nonSeasonal = try container.decode([PlantDetail:Timetable].self, forKey: .nonSeasonal)
        notes = try container.decode(String.self, forKey: .notes)
    }
    
    init(_ name: String = "") {
        id = (CareInstructions.manager?.newId())!
        self.name = name
        seasonal = [.water:SeasonalSchedule(),
                    .fertilize:SeasonalSchedule(),
                    .pestControl:SeasonalSchedule(),
                    .sun:SeasonalSchedule()]
        nonSeasonal = [.prune:Timetable(Pruning(""), ActionFrequency())]
        notes = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(seasonal, forKey: .seasonal)
        try container.encode(nonSeasonal, forKey: .nonSeasonal)
        try container.encode(notes, forKey: .notes)
    }
    
    func detail(_ item: PlantDetail) -> CareDetail? {
        switch item {
        case .water:
            return .water(currentSeason(.water))
        case .sun:
            return .sun(currentSeason(.sun))
        case .fertilize:
            return .fertilize(currentSeason(.fertilize))
        case .pestControl:
            return .pestControl(currentSeason(.pestControl))
        case .prune:
            return .prune
        case .repot:
            return .repot
        default:
            return nil
        }
    }
    
    func currentSeason(_ detail: PlantDetail) -> Season {
        if !seasonal.keys.contains(detail) {
            return Season.allYear
        }
        return Season.Manager.find(Date(), in: seasonal[detail]!.seasons)
    }
    
    func persist() throws {
        try Documents.instance?.store(self, as: id)
        try CareInstructions.manager?.add(self)
    }
    
    func unpersist() throws {
        try Documents.instance?.remove(id)
        try CareInstructions.manager?.remove(self)
    }
}
