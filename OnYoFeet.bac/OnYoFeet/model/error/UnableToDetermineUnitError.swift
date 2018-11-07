//
//  UnableToDetermineUnitError.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/28/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class UnableToDetermineUnitError : Error {
    var unitType: String
    var defaut: String?
    var extraInfo: String?
    var message: String {
        var msg = "Unable to determine unit for \(unitType)."
        if defaut == nil {
            if extraInfo != nil {
                msg += " \(extraInfo ?? "")"
            }
        }
        else {
            msg += " Defaulting to \(defaut ?? "?")"
        }
        return msg
    }
    
    init(_ unitType: String, _ defaut: String? = nil, _ extraInfo: String? = nil) {
        self.unitType = unitType
        self.defaut = defaut
        self.extraInfo = extraInfo
    }
}
