//
//  DateMO+CoreDataClass.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DateMO)
public class DateMO: TimeMO {
    static func create(from time :Date, with context :NSManagedObjectContext) -> DateMO {
        let mo = DateMO(context: context)
        mo.date = time as NSDate
        return mo
    }
}
