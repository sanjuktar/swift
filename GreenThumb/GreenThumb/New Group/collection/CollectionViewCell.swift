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
    @IBOutlet weak var deleteButton: UIButton!
    
    static func get(_ parent: CollectionViewController, _ label: String, _ image: UIImage, _ indexPath: IndexPath, _ editMode: Bool) -> CollectionViewCell {
        parent.collection?.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ReuseId.collectionCell)
        let cell = parent.collection?.dequeueReusableCell(withReuseIdentifier: ReuseId.collectionCell, for: indexPath) as! CollectionViewCell
        
        cell.deleteButton.isHidden = !editMode
        cell.nameLabel.text = label
        cell.nameLabel.sizeToFit()
        cell.center(horizontally: cell.nameLabel)
        cell.imageView.image = image
        cell.imageView.sizeToFit()
        
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
