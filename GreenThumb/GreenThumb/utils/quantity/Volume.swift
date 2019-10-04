//
//  Volume.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/9/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum Volume: Quantity {
    case any
    case ml(Int)
    case oz(Double)
    case drops(Int)
    case tbsp(Double)
    case custom(String)
    case customUnit(Int, String)
    
    enum CodingKeys: String, CodingKey {
        case desc
    }
    
    var description: String {
        switch self {
        case .any:
            return "any"
        case .ml(let n):
            return "\(n)\(self.suffix)"
        case .oz(let n):
            return "\(n)\(self.suffix)"
        case .drops(let n):
            return "\(n)\(self.suffix)"
        case .tbsp(let n):
            return "\(n)\(self.suffix)"
        case .custom(let s):
            return s
        case .customUnit(let n,_):
            return "\(n)\(self.suffix)"
        }
    }
    var suffix: String {
        switch self {
        case .any:
            return ""
        case .ml(_):
            return "ml"
        case .oz(_):
            return "oz"
        case .drops(_):
            return " drops"
        case .tbsp(_):
            return "tbsp"
        case .custom(let str):
            return str
        case .customUnit(_, let str):
            return " \(str)"
        }
    }
    
    static func from(_ description: String) -> Quantity {
        switch description {
        case pattern(.any):
            return Volume.any
        case pattern(.ml(0)):
            return Volume.ml(Int(pattern(.ml(0)).match(description))!)
        case pattern(.oz(0)):
            return Volume.oz(Double(pattern(.oz(0)).match(description))!)
        case pattern(.drops(0)):
            return Volume.drops(Int(pattern(.drops(0)).match(description))!)
        case pattern(.tbsp(0)):
            return Volume.tbsp(Double(pattern(.tbsp(0)).match(description))!)
        case pattern(.customUnit(0,"")):
            let matches = pattern(.customUnit(0, "")).matches(description)
            return Volume.customUnit(Int(matches[0])!, matches[1])
        default:
            return Volume.custom(description)
        }
    }
    
    fileprivate static func pattern(_ unit: Volume) -> Regex {
        switch unit {
        case .any:
            return Regex(stringLiteral: Volume.any.description)
        case .ml(_), .oz(_), .drops(_), .tbsp(_):
            return Regex(stringLiteral: "\(Regex.decimalNumber)\(unit.suffix)")
        case .custom(_):
            return Regex(stringLiteral: Regex.someString)
        case .customUnit(_,_):
            return Regex(stringLiteral: "\(Regex.decimalNumber) Volume.ml(0).suffix")
        }
    }
    
    init(from decoder: Decoder) throws {
        let desc = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .desc)
        self = Volume.from(desc) as! Volume
    }
    
    init(from description: String) {
        self = Volume.from(description) as! Volume
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .desc)
    }
}
