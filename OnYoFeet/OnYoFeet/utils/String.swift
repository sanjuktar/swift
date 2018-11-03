//
//  String.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

extension String {
    init(duration: TimeInterval) {
        let (allMinutes,seconds) = Int(duration).quotientAndRemainder(dividingBy: 60)
        let (hours, minutes) = allMinutes.quotientAndRemainder(dividingBy: 60)
        self.init("\(seconds)s")
        if hours > 0 {
            self = "\(hours)h \(minutes)m " + self
        }
        else if minutes > 0 {
            self = "\(minutes)m " + self
        }
    }
    
    init(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        self.init("\(formatter.string(from: date))")
    }
}
