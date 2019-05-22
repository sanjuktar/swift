//
//  Storage.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

/*typealias ObjectId = String

protocol IdedObj {
    var id:  String {get}
}

extension IdedObj {
    func createId(with unique: String) -> String {
        return "\(type(of: self))_\(unique)"
    }
}*/

protocol Storage {
    func store<T: Storable>(_ object: T, as filename: String) throws
    func retrieve<T: Storable>(_ fileName: String, as type: T.Type) throws -> T
    func clear() throws
    func remove(_ fileName: String) throws
    func fileExists(_ fileName: String) -> Bool
}
