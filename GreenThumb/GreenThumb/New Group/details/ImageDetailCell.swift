//
//  ImageDetailCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/1/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class ImageDetailCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    static func get(_ detailsVC: DetailsViewController, _ image: UIImage? = nil, _ editMode: Bool = false) -> ImageDetailCell {
        detailsVC.table?.register(UINib(nibName: "ImageDetailCell", bundle: nil), forCellReuseIdentifier: ReuseId.imageDetailCell)
        let cell = detailsVC.table?.dequeueReusableCell(withIdentifier: ReuseId.imageDetailCell) as! ImageDetailCell
        cell.cameraButton.isHidden = !editMode
        cell.backgroundColor = DetailsConstants.Table.Cell.Color.background
        return cell
    }
}
