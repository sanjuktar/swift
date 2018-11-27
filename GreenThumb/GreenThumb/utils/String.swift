//
//  String.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

extension String {
    var isAlphaNoDiacritics: Bool {
        return !self.isEmpty && self.range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    var isAlpha: Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    var isAlphaNum: Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil 
    }
    
    var djb2hash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
    var sdbmhash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(0) {
            Int($1) &+ ($0 << 6) &+ ($0 << 16) - $0
        }
    }
}
