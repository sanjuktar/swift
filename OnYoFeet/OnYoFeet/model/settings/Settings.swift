//
//  Settings.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class Settings {
    static var current: Settings? = (UIApplication.shared.delegate as! AppDelegate).settings
    var units: MeasurementUnits
    var tripTemplate: TripTemplate
    var numSavedTrips: Int
    
    init(units: MeasurementUnits = MeasurementUnits.metric(), template: TripTemplate = TripTemplate("Default"), numSavedTrips :Int = 10) {
        self.units = units
        self.tripTemplate = template
        self.numSavedTrips = numSavedTrips
    }
}
