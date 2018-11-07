//
//  AltimeterError.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/26/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum AltimeterError: OnYoFeetError {
    case noAuth
    case notAvailable
    case error(Error)
    case custom(String)
    
    var message: String {
        let prefix = "Altimeter error: "
        switch self {
        case .noAuth:
            return prefix + "No authorization to read data."
        case .notAvailable:
            return prefix + "Data is not available."
        case .error(let err):
            return prefix + "\(err)"
        case .custom(let str):
            return prefix + "\(str)"
        }
    }
    
    init(_ error: Error) {
        self = .error(error)
    }
    
    init(_ str: String) {
        self = .custom(str)
    }
}
