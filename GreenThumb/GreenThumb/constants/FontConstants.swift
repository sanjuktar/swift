//
//  FontConstants.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/18/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class FontConstants {
    class Table {
        class Cell {
            static var titleLabel: UIFont = UIFont(name: "detailName", size: 5) ?? UIFont.preferredFont(forTextStyle: .body)
            static var detailLabel: UIFont = UIFont(name: "detailValue", size: 5) ?? UIFont.preferredFont(forTextStyle: .body)
        }
    }
}
