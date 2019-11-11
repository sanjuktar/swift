//
//  ImageDetailCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/1/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class ImageDetailCell: DetailsTableCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    static var height: CGFloat {
        return 175
    }
    
    static func get(_ tableView: UITableView, _ image: UIImage? = nil, _ editMode: Bool = false) -> ImageDetailCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageDetailCell") as! ImageDetailCell
        cell.cameraButton.isHidden = !editMode
        return cell
    }
}
