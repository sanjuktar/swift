//
//  ObjectDetails.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/3/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol ObjectDetail: Equatable, CustomStringConvertible {
    associatedtype ObjectType:AnyObject
    static var sections: [String] {get}
    var seguesToDetails: Bool {get}
    var cellHeight: CGFloat {get}
    static func items(in section: Int) -> [String]
    static func item(_ section: Int, _ pos: Int) -> Self?
    static func == (left: Self, right: Self) -> Bool
    func equals(_ detail: Self) -> Bool
    func value(for obj: ObjectType) -> Any?
    func validate(_ obj: ObjectType) -> Bool
    func modify(_ obj: ObjectType, with value: Any) -> Bool
    func cell(_ controller: DetailsViewController, obj: ObjectType?, editMode: Bool) -> UITableViewCell
}

extension ObjectDetail {
    static var unknownValue: String {
        return "Unable to get plant detail"
    }
    
    static func == (left: Self, right: Self) -> Bool {
        return left.equals(right)
    }
}
