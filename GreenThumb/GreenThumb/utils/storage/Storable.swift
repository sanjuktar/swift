//
//  Storable.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/18/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

protocol Storable: Codable {
    var version: String {get}
    var name: String {get}
}
