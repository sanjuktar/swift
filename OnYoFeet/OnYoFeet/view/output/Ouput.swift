//
//  Log.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/19/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import os

let subsystem = "com.manaroystudio.onYoFeet"

protocol Output {
    var types: OutputTypeList {get set}
    func enable(_ type: OutputType)
    func disable(_ type: OutputType)
    func output(_ type: OutputType, _ message: String)
    func out(_ type: OutputType, _ message: String)
}

extension Output {
    func enable(_ type: OutputType) {
        types.add(type)
    }
    
    func disable(_ type: OutputType) {
        types.remove(type)
    }
    
    func output(_ type: OutputType, _ message: String) {
        if !types.contains(type) {
            return
        }
        out(type, message)
    }
}
