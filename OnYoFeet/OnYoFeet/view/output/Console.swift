//
//  Console.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/26/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import os

class Console : Output {
    var category: String
    var types: OutputTypeList
    
    init(_ category: String, _ logTypes: OutputTypeList = OutputTypeList()) {
        self.category = category
        types = logTypes
    }
    
    func out(_ type: OutputType, _ message: String) {
        var prefix: String
        switch OutputType(type.rawValue) {
        case .info: prefix = "Info"
        case .debug: prefix = "Debug"
        case .error: prefix = "ERROR"
        case .fault: prefix = "FAULT!!!"
        default: prefix = "UNKNOWN_LOG_TYPE"
        }
        print("\(prefix)(\(category)): \(message)")
    }
}
