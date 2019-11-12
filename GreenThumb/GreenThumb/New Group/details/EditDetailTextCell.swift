//
//  EditPlantTextCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditDetailTextCell: DetailsTableCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    
    static func get(_ detailsVC: PlantDetailsViewController, _ label: String, _ detail: String) -> EditDetailTextCell {
        let cell = detailsVC.detailsTable.dequeueReusableCell(withIdentifier: "editDetailTextCell") as! EditDetailTextCell
        cell.titleLabel.text = label
        cell.detailTextField.text = detail
        cell.detailTextField.delegate = detailsVC
        cell.titleLabel.sizeToFit()
        cell.customize()
        return cell
    }
    
    override func customize() {
        super.customize()
        titleLabel.font = DetailsTableCell.labelFont
        titleLabel.textColor = DetailsTableCell.labelColor
        titleLabel.sizeToFit()
    }
}
