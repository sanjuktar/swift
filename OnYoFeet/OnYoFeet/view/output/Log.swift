//
//  Log.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/26/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import os

class Log : Output {
    var obj: OSLog
    var category: String
    var types: OutputTypeList
    
    init(_ category: String, _ logTypes: OutputTypeList = OutputTypeList()) {
        obj = OSLog(subsystem: subsystem, category: category)
        self.category = category
        types = logTypes
    }
    
    func out(_ type: OutputType, _ message: String) {
        os_log("%@", log: obj, type: type, message)
    }
}
