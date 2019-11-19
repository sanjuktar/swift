//
//  ColorConstants.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/18/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class ColorConstants {
    static func fromRgb(_ red: Float, _ green: Float, _ blue: Float, _ alpha: CGFloat = 1.0) -> UIColor{
        return UIColor(displayP3Red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: alpha)
    }
    
    class TableCell {
        static var background = fromRgb(123, 150, 124)
        static var text = UIColor.white
        static var textField = UIColor.white
    }
}
