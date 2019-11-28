//
//  LocationDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/30/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

enum LocationDetail: String, Codable, ObjectDetail {
    typealias ObjectType = Location
    
    enum Section: String, CaseIterable {
        case noHeader = ""
        case conditions = "Conditions"
    }
    
    case image = "Image"
    case name = "Name:"
    case plants = "Plants"
    case inOrOut = "Exposure:"
    case light = "Light:"
    case rain = "Rain:"
    case wind = "Wind/Draft:"
    case humidity = "Humidity"
    
    static var details: [Section:[LocationDetail]] = [
        .noHeader:[.image, .name, .plants],
        .conditions:[.inOrOut, .light, .rain, .wind, .humidity]
    ]
    
    static var indoorDetails: [LocationDetail] {
        return [.name, .plants, .inOrOut, .light, .humidity]
    }
    
    static var outdoorDetails: [LocationDetail] {
        return [.name, .plants, .inOrOut, .light, .rain, .wind, .humidity]
    }
    static var sections: [String] {
        return Section.allCases.map{$0.rawValue}
    }
    
    static func items(in section: Int) -> [String] {
        return details[Section.allCases[section]]?.map{$0.rawValue} ?? []
    }
    
    static func item(_ section: Int, _ pos: Int) -> LocationDetail? {
        return details[Section.allCases[section]]?[pos]
    }
    
    var description: String {
        return rawValue
    }
    var segueOnSelection: Bool {
        return false
    }
    var cellHeight: CGFloat {
        return self == .image ? DetailsConstants.Table.Cell.Height.imageCell : DetailsConstants.Table.Cell.Height.detailCell
    }
    
    static func update(_ location: Location, _ condition: Conditions, _ slider: UISlider) throws {
        var values: [Conditions]
        var detail: ConditionsType
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
    
    static func validate(_ location: Location) -> Bool {
        for detail in details(location) {
            if !detail.validate(location) {
                return false
            }
        }
        return true
    }
    
    func equals(_ detail: LocationDetail) -> Bool {
        return rawValue == detail.rawValue
    }
    
    func value(for location: Location) -> Any? {
        switch self {
        case .name:
            return location.name
        case .image:
            return location.image
        case .plants:
            return location.plants.map{Plant.manager!.get($0)!.name}.joined(separator: ", ")
        case .inOrOut:
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
    
    func validate(_ obj: Location) -> Bool {
        return !obj.name.isEmpty
    }
    
    func cell(_ controller: EditableTableViewController, obj: Location?, editMode: Bool) -> UITableViewCell {
        var cell: UITableViewCell?
        switch self {
        case .name:
            cell = EditableDetailTextCell.get(controller, rawValue, value(for: obj!) as! String, editMode: editMode)
        case .image:
            cell = ImageDetailCell.get(controller, obj?.image, editMode)
        case .plants:
            cell = EditableDetailTextCell.get(controller, rawValue, value(for: obj!) as! String, editMode: false)
        case .inOrOut:
            let value = InOrOut.Values(rawValue: obj!.conditions.value(.inOrOut).name)!
            cell = EditDetailWithSliderCell.get(
                rawValue,
                values: InOrOut.values.map{$0.rawValue},
                pos: InOrOut.values.firstIndex(of: value),
                parent: controller)
        case .light:
            let value = LightExposure.Values(rawValue: obj!.conditions.value(.light).name)
            cell = EditDetailWithSliderCell.get(
                rawValue,
                values: LightExposure.values.map{$0.rawValue},
                pos: LightExposure.values.firstIndex(of: value!)!,
                parent: controller)
        case .rain:
            let value = Rain.Values(rawValue: obj!.conditions.value(.rain).name)
            cell = EditDetailWithSliderCell.get(
                rawValue,
                values: Rain.values.map{$0.rawValue},
                pos: Rain.values.firstIndex(of: value!),
                parent: controller)
        case .wind:
            let value = Wind.Values.get(obj!.conditions.value(.wind).name)
            cell = EditDetailWithSliderCell.get(
                rawValue,
                values: Wind.values.map{$0.name},
                pos: Wind.values.firstIndex(of: value!),
                parent: controller)
        case .humidity:
            let value = Humidity.Values(rawValue: obj!.conditions.value(.humidity).name)
            cell = EditDetailWithSliderCell.get(
                rawValue,
                values: Humidity.values.map{$0.rawValue},
                pos: Humidity.values.firstIndex(of: value!),
                parent: controller)
        }
        if let c = cell as? EditableDetailTextCell {
            (controller.textController as! DetailTextFieldDelegate<LocationDetail>).add(textField: c.detailValueTextField, edits: self)
        }
        else if let c = cell as? EditDetailWithSliderCell {
            (controller.sliderController as! DetailsSliderController<LocationDetail>).add(slider: c.detailValueSlider, edits: self)
        }
        return cell ?? EditableDetailTextCell.get(controller, "", "Unknown value", editMode: false)
    }
    
    func modify(_ obj: Location, with value: Any?) -> Bool {
        switch self {
        case .name:
            if let s = value as? String {
                if !s.isEmpty {
                    obj.name = s
                    return true
                }
            }
            return false
        case .image:
            if value == nil {
                obj.image = nil
                return true
            }
            if let i = value as? UIImage {
                obj.image = i
                return true
            }
            return false
        case .plants:
            return false
        case .inOrOut:
            if let val = value as? InOrOut {
                obj.conditions.addValue(.inOrOut, season: Defaults.seasonal.season, value: val)
                return true
            }
            return false
        case .light:
            if let val = value as? Light {
                obj.conditions.addValue(.light, season: Defaults.seasonal.season, value: val.quantity)
                return true
            }
            return false
        case .rain:
            if let val = value as? Rain {
                obj.conditions.addValue(.rain, season: Defaults.seasonal.season, value: val)
                return true
            }
            return false
        case .wind:
            if let val = value as? Wind {
                obj.conditions.addValue(.wind, season: Defaults.seasonal.season, value: val)
                return true
            }
            return false
        case .humidity:
            if let val = value as? Humidity {
                obj.conditions.addValue(.humidity, season: Defaults.seasonal.season, value: val)
                return true
            }
            return false
        }
    }
}
