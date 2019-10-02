//
//  GenericError.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class GenericError : Error, CustomStringConvertible {
    var localizedDescription: String
    var description: String {
        return localizedDescription
    }
    
    init(_ desc: String, specs: String = "") {
        AppDelegate.current?.log?.out(.error, "\(specs)\(!specs.isEmpty ? "" : ": ")\(desc)")
        localizedDescription = desc
    }
}
