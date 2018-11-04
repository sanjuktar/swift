//
//  Trip.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 8/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Trip: CodableObj {
    var name: String?
    var start: Date?
    var end: Date?
    var lastUpdate: Date?
    var distance: Double = 0
    var currentPace: Double = 0
    var climb: Double = 0
    var incline: Double = 0
    var duration: TimeInterval {
        guard let _ = start else {return 0}
        if inProgress {
            return lastUpdate!.timeIntervalSince(start!)
        }
        return end!.timeIntervalSince(start!)
    }
    var inProgress: Bool {
        if let _ = end {
            return false
        }
        return start != nil
    }
    var averagePace: Double {
        let d = duration
        return d == 0 ? 0 : distance/d
    }
    var id: String {
        return createId(with: name!)
    }
    
    init(_ name: String = "") {
        self.name = name
    }
    
    func startTrip() {
        reset()
        start = Date()
        lastUpdate = start
    }
    
    func stopTrip() {
        end = Date()
        lastUpdate = end
    }
    
    private func reset() {
        start = nil
        end = nil
        lastUpdate = nil
        distance = 0
        currentPace = 0
        climb = 0
        incline = 0
    }
}
