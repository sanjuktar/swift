//
//  LocationDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/30/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

enum LocationDetail: String, Codable {
    case name = "Name:"
    case image = "Image"
    case plants = "Plants"
    case indoors = "Indoor/Outdoor:"
    case light = "Light:"
    case rain = "Rain:"
    case wind = "Wind/Draft:"
    case humidity = "Humidity"
    
    static var indoorDetails: [LocationDetail] {
        return [.name, .plants, .indoors, .light, .humidity]
    }
    
    static var outdoorDetails: [LocationDetail] {
        return [.name, .plants, .indoors, .light, .rain, .wind, .humidity]
    }
    
    static func update(_ location: Location, _ condition: Condition, _ slider: UISlider) throws {
        var values: [Condition]
        var detail: Location.Conditions
        switch condition {
        case is InOrOut:
            values = InOrOut.values.map{InOrOut($0)}
            detail = .inOrOut
        case is LightExposure:
            values = LightExposure.values.map{LightExposure($0)}
            detail = .light
        case is Rain:
            values = Rain.values.map{Rain($0)}
            detail = .rain
        case is Humidity:
            values = Humidity.values.map{Humidity($0)}
            detail = .humidity
        case is Wind:
            values = Wind.values.map{Wind($0)}
            detail = .wind
        default:
            throw GenericError("Unable to determine which location condition needs updating.")
        }
        location.conditions[detail]?[location.currentSeason(detail)] = values[Int(slider.value*Float(values.count))]
    }
    
    func data(for location: Location) -> String {
        let unknown = "<unknown>"
        switch self {
        case .name:
            return location.name
        case .image:
            return "No Image"
        case .plants:
            return (Plant.manager?.plants(at: location).map{$0.name}.joined(separator: ", "))!
        case .indoors:
            return location.value(.inOrOut)?.name ?? unknown
        case .light:
            return location.value(.light)?.name ?? unknown
        case .rain:
            return location.value(.rain)?.name ?? unknown
        case .wind:
            return location.value(.wind)?.name ?? unknown
        case .humidity:
            return location.value(.humidity)?.name ?? unknown
        }
    }
    
    func tableCell(for location: Location, in table: UITableView, editFlag: Bool = false) -> UITableViewCell {
        switch self {
        case .name:
            if editFlag {
                return EditLocDetailTextCell.getCell(rawValue, data(for: location), table: table)
            }
            else {
                return LocDetailWithLabelCell.getCell(rawValue, data(for: location), table: table)
            }
        case .image:
            return EditLocDetailTextCell.getCell(rawValue, data(for: location), table: table)
        case .plants:
            return EditLocDetailTextCell.getCell(rawValue, data(for: location), table: table)
        case .indoors:
            let value = InOrOut.Values(rawValue: location.condition(.inOrOut).name)!
            return EditLocDetailWithSliderCell.getCell(rawValue, values: InOrOut.values.map{$0.rawValue}, pos: InOrOut.values.firstIndex(of: value), table: table, editMode: editFlag)
        case .light:
            let value = LightExposure.Values(rawValue: location.condition(.light).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: LightExposure.values.map{$0.rawValue}, pos: LightExposure.values.firstIndex(of: value!)!, table: table, editMode: editFlag)
        case .rain:
            let value = Rain.Values(rawValue: location.condition(.rain).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: Rain.values.map{$0.rawValue}, pos: Rain.values.firstIndex(of: value!), table: table, editMode: editFlag)
        case .wind:
            let value = Wind.Values.get(location.condition(.wind).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: Wind.values.map{$0.name}, pos: Wind.values.firstIndex(of: value!), table: table, editMode: editFlag)
        case .humidity:
            let value = Humidity.Values(rawValue: location.condition(.humidity).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: Humidity.values.map{$0.rawValue}, pos: Humidity.values.firstIndex(of: value!), table: table, editMode: editFlag)
        }
    }
}
