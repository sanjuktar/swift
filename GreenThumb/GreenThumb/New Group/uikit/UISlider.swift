//
//  UISlider.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/5/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

extension UISlider {
    func setThumbnailText(_ text: String) {
        var image = UIImage.getRectangle(CGSize(width: 70, height: 40), UIColor.lightGray)
        //var image = UIImage(imageLiteralResourceName: "rounded-rectangle")
        //image = UIImage.resize(image, CGSize(width: 70, height: 20))
        image = UIImage.addText(image, text, atPoint: CGPoint(x: 0, y: 0), color: UIColor.black)
        image = UIImage.roundCorners(image, 30)
        setThumbImage(image, for: .normal)
        setThumbImage(image, for: .highlighted)
    }
}
