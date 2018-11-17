//
//  WordyError.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/8/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

protocol WordyError: Error {
    var message: String {get}
}

extension WordyError {
    func throwError() throws {
        throw GenericError(message)
    }
}
