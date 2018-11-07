//
//  OnYoError.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/19/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

protocol OnYoFeetError: Error {
    var message: String {get}
}

extension OnYoFeetError {
    func throwError() throws {
        throw GenericError(message)
    }
}

class GenericError : Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}
