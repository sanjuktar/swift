//
//  UIImage.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/2/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

extension UIImage {
    var imageData: Data? {
        return jpegData(compressionQuality: 0.5)
    }
    
    static func getRectangle(_ size: CGSize, _ color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func roundCorners(_ image: UIImage, _ radius: CGFloat) -> UIImage {
        var imageView = UIImageView()
        if image.size.width > image.size.height {
            imageView.frame =  CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        }
        else {
            imageView = UIImageView(image: image)
            
        }
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
    static func resize(_ image: UIImage, _ size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func addText(_ image: UIImage, _ text: String, atPoint point: CGPoint, font: UIFont = UIFont(name: "Helvetica Bold", size: 12)!, color: UIColor = UIColor.darkGray) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let rect = CGRect(origin: point, size: image.size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        (text as NSString).draw(with: rect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
