//
//  TimeMO+CoreDataClass.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TimeMO)
public class TimeMO: NSManagedObject {
    var time :Time? {
        switch self {
        case self as! AnytimeOfDayMO: return AnytimeOfDay()
        case self as! AnytimeMO: return Anytime()
        case self as! TimeOfDayMO: return TimeOfDay((self as! TimeOfDayMO).nSeconds)
        case self as! DateMO: return (self as! DateMO).date as Date?
        default: return nil
        }
    }
    
    func copy(to time : inout Time) {
        switch self {
        case self as! AnytimeOfDayMO:
            if !(time is AnytimeOfDay) {
                time = AnytimeOfDay()
            }
            return
        case self as! AnytimeMO:
            if !(time is Anytime) {
                time = Anytime()
            }
            return
        case self as! TimeOfDayMO:
            if !(time is TimeOfDay) {
                time = TimeOfDay((self as! TimeOfDayMO).nSeconds)
            }
            else {
                (time as! TimeOfDay).nSeconds = (self as! TimeOfDayMO).nSeconds
            }
            return
        case self as! DateMO:
            let moDate = (self as! DateMO).date! as Date
            if !(time is Date) {
                time = moDate
            }
            else {
                var objDate = time as! Date
                objDate += moDate.timeIntervalSince(objDate)
            }
            return
        default: return
        }
    }
}

extension Time {
    func managedObj(withContext context: NSManagedObjectContext) -> TimeMO? {
        if self is AnytimeOfDay {
            return AnytimeOfDayMO.create(with: context)
        }
        if self is Anytime {
            return AnytimeMO.create(with: context)
        }
        if self is TimeOfDay {
            return TimeOfDayMO.create(from: self as! TimeOfDay, with: context)
        }
        if self is Date {
            return DateMO.create(from: self as! Date, with: context)
        }
        return nil
    }
}
