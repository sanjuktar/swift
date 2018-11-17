//
//  TextType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

func formatDouble(_ val: Double, _ format: String = "%.1f") -> String {
    return String(format: format, val)
}

struct TextType {
    enum Category: String {
        case string = "String"
        case int = "Integer"
        case double = "Double"
    }
    
    enum ValidationResult {
        case success, emptyNotOk, notCorrectType
    }
    
    var type: Category?
    var emptyOk: Bool = false
    var isNumeric: Bool {
        switch type! {
        case .int, .double:
            return true
        default:
            return false
        }
    }
    var increment: Double {
        switch type! {
        case .string:
            return 0
        case .int:
            return 1
        case .double:
            return 0.1
        }
    }
    
    init(_ type: Category, emptyOk: Bool = false) {
        self.type = type
        self.emptyOk = emptyOk
    }
    
    func validate(_ text: String) -> ValidationResult {
        switch type! {
        case .string:
            return emptyOk || !text.isEmpty ? .success : .emptyNotOk
        case .int:
            return Int(text) != nil ? .success : .notCorrectType
        case .double:
            return Double(text) != nil ? .success : .notCorrectType
        }
    }
    
    func text(_ val: Any) -> String {
        if val is String {
            return val as! String
        }
        if val is Int {
            let v = val as! Int
            switch type! {
            case .string, .int:
                return v.description
            case .double:
                return formatDouble(Double(v))
            }
        }
        if val is Double {
            let v = val as! Double
            switch type! {
            case .string, .double:
                return formatDouble(v)
            case .int:
                return Int(v).description
            }
        }
        return "Dont know"
    }
}
