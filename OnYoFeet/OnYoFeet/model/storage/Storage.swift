//
//  Storage.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 11/2/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

typealias ObjectId = String

protocol CodableObj: Codable {
    var id:  String {get}
}

extension CodableObj {
    func createId(with unique: String) -> String {
        return "\(type(of: self))_\(unique)"
    }
}

protocol Storage {
    func store<T: CodableObj>(_ object: T, as filename: String?) throws
    func retrieve<T: CodableObj>(_ fileName: String, as type: T.Type) throws -> T
    func clear() throws
    func remove(_ fileName: String) throws
    func fileExists(_ fileName: String) -> Bool
}
