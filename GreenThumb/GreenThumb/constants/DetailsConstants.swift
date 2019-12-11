//
//  DetailsConstants.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/18/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailsConstants {
    class Table {
        class Cell {
            class Color {
                static var background = UIColor.clear
                static var text = ColorConstants.Table.text
                static var textFieldText = ColorConstants.TextField.text
                static var textFieldBg = ColorConstants.TextField.background
            }
            class Font {
                static var titleLabel = FontConstants.Table.Cell.titleLabel
                static var detailLabel = FontConstants.Table.Cell.titleLabel
            }
            class Height {
                static var detailCell: CGFloat = 50.0
                static var imageCell: CGFloat = 175.0
                static var sliderCell: CGFloat = 50.0
            }
        }
        static var backgroundColor = ColorConstants.Table.background
    }
}
