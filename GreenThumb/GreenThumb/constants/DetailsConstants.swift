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
                static var background = ColorConstants.TableCell.background
                static var label: UIColor = ColorConstants.TableCell.text
            }
            class Font {
                static var titleLabel = FontConstants.Table.Cell.titleLabel
                static var detailLabel = FontConstants.Table.Cell.titleLabel
            }
            class Height {
                static var detailCell: CGFloat = 50.0
                static var imageCell: CGFloat = 175.0
            }
        }
    }
}
