//
//  TimeOfDayMO+CoreDataClass.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TimeOfDayMO)
public class TimeOfDayMO: TimeMO {
    static func create(from time :TimeOfDay, with context :NSManagedObjectContext) -> TimeOfDayMO {
        let mo = TimeOfDayMO(context: context)
        mo.nSeconds =  time.nSeconds
        return mo
    }
}
