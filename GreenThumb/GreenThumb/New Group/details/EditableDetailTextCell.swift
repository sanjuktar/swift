//
//  EditableDetailTextCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditableDetailTextCell: UITableViewCell {
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailValueTextField: UITextField!
    
    var seguesOnSelect = false
    
    static func get(_ detailsVC: DetailsViewController, _ label: String, _ detail: String, editMode: Bool = true) -> EditableDetailTextCell {
        detailsVC.table?.register(UINib(nibName: "EditableDetailTextCell", bundle: nil), forCellReuseIdentifier: ReuseId.editDetailTextCell)
        let cell = detailsVC.table!.dequeueReusableCell(withIdentifier: ReuseId.editDetailTextCell) as! EditableDetailTextCell
        cell.customize(label, detail)
        cell.setEditMode(editMode)
        cell.detailValueTextField.delegate = detailsVC.textController
        return cell
    }
    
    static func getWithDisclosure(_ detailsVC: DetailsViewController, _ label: String, _ detail: String) -> EditableDetailTextCell {
        detailsVC.table?.register(UINib(nibName: "EditableDetailTextCell", bundle: nil), forCellReuseIdentifier: ReuseId.editDetailTextCell)
        let cell = detailsVC.table!.dequeueReusableCell(withIdentifier: ReuseId.editDetailTextCell) as! EditableDetailTextCell
        cell.customize(label, detail)
        cell.accessoryType = .disclosureIndicator
        cell.setEditMode(false)
        cell.seguesOnSelect = true
        cell.detailValueTextField.isUserInteractionEnabled = false
        return cell
    }
    
    func customize(_ label: String, _ detail: String) {
        backgroundColor = DetailsConstants.Table.Cell.Color.background
        self.selectionStyle = .none
        detailTitleLabel.text = label
        detailValueTextField.text = detail
        detailTitleLabel.font = DetailsConstants.Table.Cell.Font.titleLabel
        detailTitleLabel.textColor = DetailsConstants.Table.Cell.Color.label
        detailTitleLabel.sizeToFit()
        detailTitleLabel.sizeToFit()
    }
    
    func setEditMode(_ flag: Bool) {
        guard !seguesOnSelect else {return}
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
