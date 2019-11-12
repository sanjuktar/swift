//
//  ObjectDetails.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/3/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol ObjectDetail: Equatable, CustomStringConvertible {
    associatedtype T:AnyObject
    static var sections: [String] {get}
    var cellHeight: CGFloat {get}
    static func items(in section: Int) -> [String]
    static func item(_ section: Int, _ pos: Int) -> Self?
    static func == (left: Self, right: Self) -> Bool
    func equals(_ detail: Self) -> Bool
    func value(for obj: T) -> Any?
    func validate(_ obj: T) -> Bool
    func modify(_ obj: T, with value: Any) -> Bool
    func cell(_ detailsVC: PlantDetailsViewController, obj: T?, editMode: Bool) -> DetailsTableCell
}

extension ObjectDetail {
    static var unknownValue: String {
        return "Unable to get plant detail"
    }
    var genericCellHeight: CGFloat {
        return 40
    }
    
    static func == (left: Self, right: Self) -> Bool {
        return left.equals(right)
    }
}
