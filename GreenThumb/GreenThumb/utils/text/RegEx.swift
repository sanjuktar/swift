//
//  RegEx.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 1/8/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

struct Regex: ExpressibleByStringLiteral, Equatable {
    static var any = ".*"
    static var someString = ".+"
    static var integer = "[0-9]+"
    static var decimalNumber = "\(integer)(\\.\(integer)?"
    fileprivate let expression: NSRegularExpression
    
    static func ~=(pattern: Regex, value: String) -> Bool {
        return !NSEqualRanges((pattern.matchResult(value)?.range)!, NSMakeRange(NSNotFound, 0))
    }
    
    init(stringLiteral: String) {
        do {
            self.expression = try NSRegularExpression(pattern: stringLiteral, options: [])
        } catch {
            AppDelegate.current?.log?.out(.error, "Failed to parse \(stringLiteral) as a regular expression")
            self.expression = try! NSRegularExpression(pattern: ".*", options: [])
        }
    }
    
    func match(_ input: String) -> String {
        return matches(input).joined()
    }
    
    func matches(_ input: String) -> [String] {
        let result = matchResult(input)
        guard result != nil && (result?.numberOfRanges)! > 0 else {return []}
        var groups = [String]()
        for i in  0..<result!.numberOfRanges {
            let group = String(input[Range(result!.range(at: i), in: input)!])
            groups.append(group)
        }
        return groups
    }
    
    fileprivate func matchResult(_ input: String) -> NSTextCheckingResult? {
        return expression.firstMatch(
            in: input, options: [], range: NSRange(input.startIndex..., in: input))
    }
}
