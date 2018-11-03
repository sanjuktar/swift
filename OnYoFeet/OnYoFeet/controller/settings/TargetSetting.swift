//
//  TargetSetting.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
fileprivate func ignoreOrVal(_ val: Double) -> String {
    return val == TripTemplate.ignore ? IgnoreStatus.ignored : "\(val)"
}

enum TargetSetting : String, SettingController {
    case pace = "Pace"
    case distance = "Distance"
    case duration = "Duration"
    case paceTolerance = "Pace tolerance"
    case durationTolerance = "Duration tolerance"
    case distaceTolerance = "Distance tolerance"
    
    static var cases: [TargetSetting] = [.pace, .distance, .duration, .paceTolerance]
    
    var name: String {
        return rawValue
    }
    
    var editType: EditType {
        let units = MeasurementUnits.current
        let target = TripTemplate.current
        switch self {
        case .pace:
            return .textEdit(name: name, current: ignoreOrVal((target?.pace)!), type: TextType(.double), detail: units.pace.rawValue)
        case .paceTolerance:
            return .textEdit(name: name, current: ignoreOrVal((target?.paceTolerance)!), type: TextType(.double), detail: units.pace.rawValue)
        case .distance:
            return .textEdit(name: name, current: ignoreOrVal((target?.distance)!), type: TextType(.double), detail: units.distance.rawValue)
        case .distaceTolerance:
            return .textEdit(name: name, current: ignoreOrVal((target?.distanceTolerance)!), type: TextType(.double), detail: units.distance.rawValue)
        case .duration:
            return .textEdit(name: name, current: ignoreOrVal((target?.duration)!), type: TextType(.double), detail: units.duration.rawValue)
        case .durationTolerance:
            return .textEdit(name: name, current: ignoreOrVal((target?.durationTolerance)!), type: TextType(.double), detail: units.duration.rawValue)
        }
    }
    
    func  ignore(_ template: TripTemplate) -> IgnoreStatus {
        switch self {
        case .distance:
            return (template.distance == TripTemplate.ignore ? .ignore(true) : .ignore(false))
        case .pace:
            return (template.pace == TripTemplate.ignore ? .ignore(true) : .ignore(false))
        case .duration:
            return (template.duration == TripTemplate.ignore ? .ignore(true) : .ignore(false))
        default:
            return .cannotIgnore
        }
    }
    
    func data(_ template: TripTemplate) -> String {
        if ignore(template) == .ignore(true) {
            return IgnoreStatus.ignored
        }
        let units = MeasurementUnits.current
        switch self {
        case .distance:
            return units.distance.string(template.distance)
        case .pace:
            return units.pace.string(template.pace)
        case .duration:
            return units.duration.string(template.duration)
        case .paceTolerance:
            return units.pace.string(template.paceTolerance)
        case .durationTolerance:
            return units.duration.string(template.durationTolerance)
        case .distaceTolerance:
            return units.distance.string(template.distanceTolerance)
        }
    }
}
