//
//  TimeOfDayMO+CoreDataProperties.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension TimeOfDayMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeOfDayMO> {
        return NSFetchRequest<TimeOfDayMO>(entityName: "TimeOfDayMO")
    }

    @NSManaged public var nSeconds: Double

}
