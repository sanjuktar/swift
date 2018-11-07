//
//  Settings.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class Settings: CodableObj {
    static var current: Settings? = (UIApplication.shared.delegate as! AppDelegate).settings
    var name: String
    var units: MeasurementUnits
    var tripTemplate: TripTemplate
    var numSavedTrips: Int
    var id: String {
        return "Settings"
    }
    static var filename: String {
        return "Settings"
    }
    
    static func save() throws {
        guard current != nil else {throw GenericError("Unable to determine current settings.")}
        do {
            try Documents.instance?.store(current!)
        } catch {
            throw error
        }
    }
    
    init(_ name: String = "", units: MeasurementUnits = MeasurementUnits.metric(), template: TripTemplate = TripTemplate("Default"), numSavedTrips :Int = 10) {
        self.name = name
        self.units = units
        self.tripTemplate = template
        self.numSavedTrips = numSavedTrips
    }
}
