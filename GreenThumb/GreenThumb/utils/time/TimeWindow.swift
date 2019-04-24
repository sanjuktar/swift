//
//  TimeWindow.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class TimeWindow :Time, Hashable {
    var start :Time
    var end :Time
    var description: String {
        return "\(String(describing: start)) to \(String(describing: end))"
    }
    var value :Date {
        return end.value
    }
    
    static func == (lhs: TimeWindow, rhs: TimeWindow) -> Bool {
        return lhs.start.equals(rhs.start) &&
            lhs.end.equals(rhs.end)
    }
    
    init(start :Time, end :Time) {
        self.start = start
        self.end = end
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(start.description + end.description)
    }
}
