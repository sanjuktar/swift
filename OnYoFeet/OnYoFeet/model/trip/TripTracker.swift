//
//  TripTracker.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class TripTracker {
    var trip: Trip
    var output: Output
    var log: Log
    
    init(_ trip: Trip, output: Output, log: Log) {
        self.trip = trip
        self.output = output
        self.log = log
    }
    
    func start() {
        trip.startTrip()
    }
    
    func stop() {
        trip.stopTrip()
    }
}
