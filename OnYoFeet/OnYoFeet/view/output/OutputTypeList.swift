//
//  OutputType.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import os

typealias OutputType = OSLogType

class OutputTypeList {
    static var defaultTypes:[OutputType] = [.info, .debug, .error, .fault]
    var types: [OutputType]
    
    init(_ types: [OutputType] = OutputTypeList.defaultTypes) {
        self.types = types
    }
    
    func contains(_ type: OutputType) -> Bool {
        return types.contains(type)
    }
    
    func add(_ type: OutputType) {
        if !types.contains(type) {
            types.append(type)
        }
    }
    
    func remove(_ type: OutputType) {
        if let pos = types.index(of: type) {
            types.remove(at: pos)
        }
    }
}

