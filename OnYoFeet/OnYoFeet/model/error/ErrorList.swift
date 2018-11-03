//
//  ErrorList.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/19/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class ErrorList {
    var list: [OnYoFeetError] = []
    
    func add(_ error: OnYoFeetError, _ output: Output? = nil) {
        if let o = output {
            o.output(.error, error.message)
        }
        list.append(error)
    }
    
    func clear() {
        list.removeAll()
    }
}
