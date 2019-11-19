//
//  EditPlantTextCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditDetailTextCell: DetailsTableCell {
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailValueTextField: UITextField!
    
    static func get(_ detailsVC: DetailsViewController, _ label: String, _ detail: String, editMode: Bool = true) -> EditDetailTextCell {
        detailsVC.table?.register(UINib(nibName: "EditDetailTextCell", bundle: nil), forCellReuseIdentifier: ReuseId.editDetailTextCell)
        let cell = detailsVC.table!.dequeueReusableCell(withIdentifier: ReuseId.editDetailTextCell) as! EditDetailTextCell
        cell.customize()
        cell.detailTitleLabel.text = label
        cell.detailTitleLabel.sizeToFit()
        cell.detailValueTextField.text = detail
        cell.detailValueTextField.delegate = detailsVC.textController
        cell.setEditMode(editMode)
        return cell
    }
    
    override func customize() {
        super.customize()
        detailTitleLabel.font = DetailsConstants.Table.Cell.Font.titleLabel
        detailTitleLabel.textColor = DetailsConstants.Table.Cell.Color.label
        detailTitleLabel.sizeToFit()
    }
    
    func setEditMode(_ flag: Bool) {
        let tf = detailValueTextField!
        if flag {
            tf.isEnabled = true
            tf.backgroundColor = UIColor.white
            tf.textColor = UIColor.darkText
            tf.borderStyle = .roundedRect
            
        }
        else {
            tf.isEnabled = false
            tf.backgroundColor = DetailsConstants.Table.Cell.Color.background
            tf.textColor = DetailsConstants.Table.Cell.Color.label
            tf.borderStyle = .none
        }
    }
}
