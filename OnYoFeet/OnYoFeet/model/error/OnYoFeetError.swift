//
//  OnYoError.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/19/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

protocol OnYoFeetError {
    var message: String {get}
}

class GenericError : Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}
