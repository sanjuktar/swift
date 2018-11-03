//
//  PedometerError.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/26/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum PedometerError: OnYoFeetError {
    case noAuth
    case paceNotAvailable
    case distanceNotAvailable
    case error(Error)
    case custom(String)
    
    var message: String {
        let prefix = "Pedometer error: "
        switch self {
        case .noAuth:
            return prefix + "No authorization to read data"
        case .paceNotAvailable:
            return prefix + "Pace data not available"
        case .distanceNotAvailable:
            return prefix + "Distance data is not available"
        case .error(let err):
            return prefix + "\(err)"
        case .custom(let str):
            return prefix + str
        }
    }
    
    init(_ err: Error) {
        self = PedometerError.error(err)
    }
    
    init(_ str: String) {
        self = PedometerError.custom(str)
    }
}
