//
//  Quantity.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

protocol Quantity: Codable, CustomStringConvertible {
    static func from(_ description: String) -> Quantity
}
