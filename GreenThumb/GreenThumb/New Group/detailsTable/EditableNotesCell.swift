//
//  EditableNotesCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditableNotesCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static func get(_ controller: EditableTableViewController, _ label: String?, _ text: String, _ editMode: Bool) -> EditableNotesCell {
        controller.table?.register(UINib(nibName: "EditableNotesCell", bundle: nil), forCellReuseIdentifier: ReuseId.editableNotesCell)
        let cell = controller.table?.dequeueReusableCell(withIdentifier: ReuseId.editableNotesCell) as! EditableNotesCell
        
        if label == nil || label!.isEmpty {
            cell.nameLabel.removeFromSuperview()
        }
        else {
            cell.nameLabel.text = label
        }
        cell.textView.text = text
        cell.setEditMode(editMode)
        
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = DetailsConstants.Table.Cell.Color.background
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setEditMode(_ flag: Bool) {
        if flag {
            textView.backgroundColor = DetailsConstants.Table.Cell.Color.textFieldBg
            textView.textColor = DetailsConstants.Table.Cell.Color.textFieldText
        }
        else {
            textView.backgroundColor = backgroundColor
            textView.textColor = DetailsConstants.Table.Cell.Color.text
        }
    }
}
