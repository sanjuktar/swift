//
//  Measurement.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/28/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum MeasurementType : String, Codable {
    case distance = "Distance"
    case pace = "Pace"
    case duration = "Duration"
    case altitude = "Altitude"
    
    static var cases: [MeasurementType] = [.distance, .pace, .duration, .altitude]
}

protocol MeasurementUnit: Codable {
    static var cases: [MeasurementUnit] {get}
    static var defaut: MeasurementUnit {get}
    var name: String {get}
    var singleName: String {get}
    var index: Int {get}
    func string(_ val: Double) -> String
}
