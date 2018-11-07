//
//  TripCompare.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class TripCompare {
    enum Pace {
        case goodSlow(Double)
        case goodFast(Double)
        case badSlow(Double)
        case badFast(Double)
        case ignored
        
        init(_ trip: Trip, _ template: TripTemplate) {
            let tolerance = template.paceTolerance
            switch trip.currentPace - template.pace {
            case let d where d < -1*tolerance: self = .badSlow(d)
            case let d where d > tolerance: self = .badFast(d)
            case let d where d < 0: self = .goodSlow(d)
            case let d: self = .goodFast(d)
            }
        }
    }
        
    enum Distance {
        case good(Double)
        case tooNear(Double)
        case tooFar(Double)
        case ignored
            
        init(_ trip: Trip, _ template: TripTemplate) {
            let tolerance = template.distanceTolerance
            switch trip.distance - template.distance {
            case let d where d < abs(tolerance): self = .good(d)
            case let d where d < -1.0*tolerance: self = .tooNear(d)
            case let d: self = .tooFar(d)
            }
        }
    }
        
    enum Duration {
        case good(Double)
        case tooShort(Double)
        case tooLong(Double)
        case ignored
            
        init(_ trip: Trip, _ template: TripTemplate) {
            let tolerance = template.durationTolerance
            switch trip.distance - template.distance {
            case let d where abs(d) < abs(tolerance): self = .good(d)
            case let d where d < -1.0*tolerance: self = .tooShort(d)
            case let d: self = .tooLong(d)
            }
        }
    }
        
    struct Results {
        var pace: Pace = .ignored
        var distance: Distance = .ignored
        var duration: Duration = .ignored
    }
        
    static func all(_ trip: Trip, _ template: TripTemplate) -> Results {
        var results = Results()
        if template.pace != TripTemplate.ignore {
            results.pace = Pace(trip, template)
        }
        if template.distance != TripTemplate.ignore {
            results.distance = Distance(trip, template)
        }
        if template.duration != TripTemplate.ignore {
            results.duration = Duration(trip, template)
        }
        return results
    }
}
