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
    
    static func update(_ location: Location, _ condition: Conditions, _ slider: UISlider) throws {
        var values: [Conditions]
        var detail: Location.ConditionsType
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
        let indx = Int(slider.value*Float(values.count))
        location.conditions.addValue(detail, value: values[indx])
    }
    
    static func details(_ location: Location) -> [LocationDetail] {
        return location.conditions.isOutdoors ? outdoorDetails : indoorDetails
    }
    
    /*init(_ condition: Location.Conditions) {
        switch condition {
        case .inOrOut:
            self = .indoors
        case .light:
            self = .light
        case .rain:
            self = .rain
        case .humidity:
            self = .humidity
        case .wind:
            self = .wind
        }
    }*/
    
    /*static func condition(_ detail: LocationDetail) -> Location.Conditions? {
        switch detail {
        case .indoors:
            return .inOrOut
        case .light:
            return .light
        case .rain:
            return .rain
        case .wind:
            return .wind
        case .humidity:
            return .humidity
        @unknown default:
            return nil
        }
    }*/
    
    func data(for location: Location) -> String {
        switch self {
        case .name:
            return location.name
        case .image:
            return "No Image"
        case .plants:
            return (Plant.manager?.plants(at: location).map{Plant.manager!.get($0)!.name}.joined(separator: ", "))!
        case .indoors:
            return location.conditions.value(.inOrOut).name
        case .light:
            return location.conditions.value(.light).name
        case .rain:
            return location.conditions.value(.rain).name
        case .wind:
            return location.conditions.value(.wind).name
        case .humidity:
            return location.conditions.value(.humidity).name
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
            let value = InOrOut.Values(rawValue: location.conditions.value(.inOrOut).name)!
            return EditLocDetailWithSliderCell.getCell(rawValue, values: InOrOut.values.map{$0.rawValue}, pos: InOrOut.values.firstIndex(of: value), table: table, editMode: editFlag)
        case .light:
            let value = LightExposure.Values(rawValue: location.conditions.value(.light).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: LightExposure.values.map{$0.rawValue}, pos: LightExposure.values.firstIndex(of: value!)!, table: table, editMode: editFlag)
        case .rain:
            let value = Rain.Values(rawValue: location.conditions.value(.rain).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: Rain.values.map{$0.rawValue}, pos: Rain.values.firstIndex(of: value!), table: table, editMode: editFlag)
        case .wind:
            let value = Wind.Values.get(location.conditions.value(.wind).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: Wind.values.map{$0.name}, pos: Wind.values.firstIndex(of: value!), table: table, editMode: editFlag)
        case .humidity:
            let value = Humidity.Values(rawValue: location.conditions.value(.humidity).name)
            return EditLocDetailWithSliderCell.getCell(rawValue, values: Humidity.values.map{$0.rawValue}, pos: Humidity.values.firstIndex(of: value!), table: table, editMode: editFlag)
        }
    }
}
