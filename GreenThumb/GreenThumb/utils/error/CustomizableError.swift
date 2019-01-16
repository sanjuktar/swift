//
//  CustomizableError.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/8/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

protocol CustomizableError: Error {
    var message: String {get}
}

extension CustomizableError {
    func throwError() throws {
        throw GenericError(message)
    }
}
