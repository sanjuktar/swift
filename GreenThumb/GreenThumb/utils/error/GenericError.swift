//
//  GenericError.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class GenericError : Error {
    var localizedDescription: String
    
    init(_ desc: String) {
        localizedDescription = desc
    }
}
