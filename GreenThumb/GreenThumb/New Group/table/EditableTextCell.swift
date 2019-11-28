//
//  EditableTextCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditableTextCell: UITableViewCell {
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailValueTextField: UITextField!
    
    var seguesOnSelect = false
    
    static func get(_ controller: EditableTableViewController, _ label: String, _ detail: String, editMode: Bool) -> EditableTextCell {
        controller.table?.register(UINib(nibName: "EditableTextCell", bundle: nil), forCellReuseIdentifier: ReuseId.editableTextCell)
        let cell = controller.table!.dequeueReusableCell(withIdentifier: ReuseId.editableTextCell) as! EditableTextCell
        cell.customize(label, detail)
        cell.setEditMode(editMode)
        cell.detailValueTextField.delegate = controller.textController
        return cell
    }
    
    static func getWithDisclosure(_ detailsVC: EditableTableViewController, _ label: String, _ detail: String) -> EditableTextCell {
        detailsVC.table?.register(UINib(nibName: "EditableTextCell", bundle: nil), forCellReuseIdentifier: ReuseId.editableTextCell)
        let cell = detailsVC.table!.dequeueReusableCell(withIdentifier: ReuseId.editableTextCell) as! EditableTextCell
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
        detailTitleLabel.textColor = DetailsConstants.Table.Cell.Color.text
        detailTitleLabel.sizeToFit()
    }
    
    func setEditMode(_ flag: Bool) {
        guard !seguesOnSelect else {return}
        let tf = detailValueTextField!
        if flag {
            tf.isEnabled = true
            tf.backgroundColor = UIColor.white
            tf.textColor = DetailsConstants.Table.Cell.Color.textFieldText
            tf.borderStyle = .roundedRect
            
        }
        else {
            tf.isEnabled = false
            tf.backgroundColor = DetailsConstants.Table.Cell.Color.background
            tf.textColor = DetailsConstants.Table.Cell.Color.text
            tf.borderStyle = .none
        }
    }
}
