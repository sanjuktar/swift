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
}

extension Storable {
    static var defaultVersion: String {
        return AppDelegate.current!.version
    }
}
