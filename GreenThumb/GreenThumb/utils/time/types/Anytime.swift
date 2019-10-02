//
//  Anytime.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

var anytime = "anytime"

protocol Anytime: Time {
    func equals(_ time: Anytime) -> Bool
}

extension Anytime {
    var name: String {
        return anytime
    }
    var description: String {
        return anytime
    }
    
    static func ==(_ lhs: Anytime, _ rhs: Anytime) -> Bool {
        return lhs.equals(rhs)
    }
}

class AnyTimeEver: Anytime {
    private static var instance: AnyTimeEver?
    static var obj: AnyTimeEver {
        if instance == nil {
            instance = AnyTimeEver()
        }
        return instance!
    }
    var name: String {
        return "\(anytime)Ever"
    }
    var value: Date {
        return Date.distantFuture
    }
    
    private init() {
    }
    
    func equals(_ time: Anytime) -> Bool {
        switch time {
        case is AnyTimeEver:
            return true
        case is AnyTimeOfDay:
            return (time as! AnyTimeOfDay).equals(self)
        case is AnyTimeOfYear:
            return (time as! AnyTimeOfYear).equals(self)
        default:
            return false
        }
    }
}

class AnyTimeOfDay: Anytime {
    var date: Date?
    var name: String {
        return "\(anytime)\(date)"
    }
    var description: String {
        return "\(anytime) on \(date)"
    }
    var value: Date {
        return date ?? TimeOfDay.end.value
    }
    
    init(on: Date? = nil) {
        self.date = on
    }
    
    func equals(_ time: Anytime) -> Bool {
        switch time {
        case is AnyTimeEver:
            return date == nil
        case is AnyTimeOfDay:
            return date == (time as! AnyTimeOfDay).date
        case is AnyTimeOfYear:
            return (time as! AnyTimeOfYear).equals(self)
        default:
            return false
        }
    }
}

class AnyTimeOfYear: Anytime {
    var year: Int?
    var name: String {
        return "\(anytime)\(year)"
    }
    var description: String {
        return "\(anytime) in \(year)"
    }
    var value: Date {
        return TimeOfYear.end.value
    }
    
    init(_ inYear: Int? = nil) {
        self.year = inYear
    }
    
    func equals(_ time: Anytime) -> Bool {
        switch time {
        case is AnyTimeEver:
            return year == nil
        case is AnyTimeOfDay:
            return year == nil && (time as! AnyTimeOfDay).date == nil
        case is AnyTimeOfYear:
            return year == (time as! AnyTimeOfYear).year
        default:
            return false
        }
    }
}
