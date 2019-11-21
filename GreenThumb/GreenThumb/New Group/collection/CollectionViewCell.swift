//
//  CollectionViewCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/20/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static func get(_ parent: CollectionViewController, _ label: String, _ image: UIImage, _ indexPath: IndexPath) -> CollectionViewCell {
        parent.collection?.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ReuseId.collectionCell)
        let cell = parent.collection?.dequeueReusableCell(withReuseIdentifier: ReuseId.collectionCell, for: indexPath) as! CollectionViewCell
        
        cell.nameLabel.text = label
        cell.imageView.image = image
        cell.nameLabel.sizeToFit()
        cell.imageView.sizeToFit()
        cell.center(horizontally: cell.nameLabel)
        
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        imageView.backgroundColor = UIColor.clear
        nameLabel.textColor = ColorConstants.Table.text
    }
    
    func center(horizontally subview: UIView) {
        subview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
