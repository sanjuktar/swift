//
//  PlantsListCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantsListCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var plant: Plant?
    
    func setup(_ plant: Plant) {
        if plant.image != nil {
            image = UIImageView(image: plant.image)
        }
        else {
            image = UIImageView(image: UIImage(imageLiteralResourceName: "noImage"))
        }
        nameLabel.text = plant.name
    }
}
