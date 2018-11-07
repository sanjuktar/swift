//
//  TripTracker.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import CoreMotion

class TripTracker {
    var trip: Trip
    var altimeter: CMAltimeter?
    var pedometer: CMPedometer?
    var log: Log
    var errors: ErrorList = ErrorList()
    
    init(_ trip: Trip, log: Log) {
        self.trip = trip
        self.altimeter = CMAltimeter()
        self.pedometer = CMPedometer()
        self.log = log
    }
    
    func start() throws {
        /*trip.startTrip()
        if CMAltimeter.authorizationStatus() == .authorized {
            if CMAltimeter.isRelativeAltitudeAvailable() {
                altimeter?.startRelativeAltitudeUpdates(to: OperationQueue.main) {
                    data, error in {
                        
                    }
                }
            }
            else {
                errors.add(AltimeterError.notAvailable)
            }
        }
        else {
            errors.add(AltimeterError.notAvailable)
        }*/
    }
    
    func stop() {
        trip.stopTrip()
    }
}
