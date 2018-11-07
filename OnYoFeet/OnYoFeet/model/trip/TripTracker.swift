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
    var altitudeData: CMAltitudeData?
    var pedometerData: CMPedometerData?
    var updateTimer: Timer?
    var pedometerTimer: Timer?
    var log: Log
    var errors: ErrorList = ErrorList()
    var timerInterval = 0.1
    
    init(_ trip: Trip, log: Log) {
        self.trip = trip
        self.altimeter = CMAltimeter()
        self.pedometer = CMPedometer()
        self.log = log
    }
    
    func start() throws {
        trip.startTrip()
        startQueries()
        updateTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) {
            timer in
            self.updateTrip()
        }
    }
    
    func stop() {
        trip.stopTrip()
        altimeter?.stopRelativeAltitudeUpdates()
        pedometer?.stopUpdates()
        updateTrip()
        if updateTimer != nil && (updateTimer?.isValid)! {
            updateTimer?.invalidate()
        }
        if pedometerTimer != nil && (pedometerTimer?.isValid)! {
            pedometerTimer?.invalidate()
        }
    }
}

extension TripTracker {
    
    private func startQueries() {
        altitudeData = nil
        pedometerData = nil
        var snapshot: (start: Date, end: Date)?
        if CMAltimeter.authorizationStatus() == .authorized ||
            CMAltimeter.authorizationStatus() == .restricted {
            if CMAltimeter.isRelativeAltitudeAvailable() {
                altimeter?.startRelativeAltitudeUpdates(to: OperationQueue.main) {
                    altitudeData, error in
                    snapshot = (self.trip.lastUpdate!, Date())
                    if error != nil {
                        self.errors.add(AltimeterError.error(error!))
                        return
                    }
                    self.altitudeData = altitudeData
                }
            }
            else {
                errors.add(AltimeterError.notAvailable)
                snapshot = (trip.lastUpdate!, Date())
            }
        }
        else {
            errors.add(AltimeterError.noAuth)
        }
        guard CMPedometer.authorizationStatus() == .authorized ||
            CMPedometer.authorizationStatus() == .restricted else {
                errors.add(PedometerError.noAuth)
                return
        }
        guard CMPedometer.isPedometerEventTrackingAvailable() else {
            errors.add(PedometerError.custom("Unable to track events"))
            return
        }
        pedometerTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) {
            timer in
            self.queryPedometer(from: snapshot!.start, to: snapshot!.end)
        }
    }

    private func queryPedometer(from: Date, to: Date) {
        guard CMPedometer.isDistanceAvailable() else {
            errors.add(PedometerError.distanceNotAvailable)
            return
        }
        guard CMPedometer.isPaceAvailable() else {
            errors.add(PedometerError.paceNotAvailable)
            return
        }
        self.pedometer?.queryPedometerData(from: from, to: to) {
            pedometerData, error in
            if error != nil {
                self.errors.add(PedometerError.error(error!))
                return
            }
            self.pedometerData = pedometerData
        }
    }
    
    private func updateTrip() {
        trip.lastUpdate = Date()
        if pedometerData != nil {
            trip.distance = (pedometerData!.distance?.doubleValue)!
            trip.currentPace = (pedometerData!.currentPace?.doubleValue)!
        }
        else {
            trip.distance = DistanceUnit.valueUnavailable
            trip.currentPace = SpeedUnit.valueUnavailable
        }
        if altitudeData != nil {
            trip.climb = altitudeData!.relativeAltitude.doubleValue
            if trip.distance > 0 {
                trip.incline = (altitudeData!.relativeAltitude.doubleValue - trip.climb)/(pedometerData!.distance?.doubleValue)!
            }
            else {
                trip.incline = 0
            }
        }
        else {
            trip.climb = DistanceUnit.valueUnavailable
            trip.incline = DistanceUnit.valueUnavailable
        }
        altitudeData = nil
        pedometerData = nil
    }
}
