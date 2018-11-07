//
//  GenericSetting.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum GenericSetting : String, SettingController {
    case numSavedTrips = "Number of trips saved"
    
    static var cases: [GenericSetting] = [.numSavedTrips]
    var name: String {
        return rawValue
    }
    var editType: EditType {
        switch self {
        case .numSavedTrips: return .textEdit(name: name, current: data, type: TextType(.int), detail: "")
        }
    }
    var data: String {
        switch self {
        case .numSavedTrips: return "\(Settings.current?.numSavedTrips ?? 0)"
        }
    }
}
