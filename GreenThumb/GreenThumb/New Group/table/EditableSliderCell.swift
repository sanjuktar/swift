//
//  EditableSliderCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditableSliderCell: UITableViewCell {
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailValueSlider: UISlider!
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            parent?.sliderValueChanged(slider)
        }
    }
    
    var parent: EditableTableViewController?
    
    static func get(_ title: String, values: [String], pos: Int? = nil, parent: EditableTableViewController , minImage: UIImage? = nil, maxImage: UIImage? = nil) -> EditableSliderCell {
        let table = parent.table
        table!.register(UINib(nibName: "EditableSliderCell", bundle: nil), forCellReuseIdentifier: ReuseId.editableSliderCell)
        let cell = table!.dequeueReusableCell(withIdentifier: ReuseId.editableSliderCell) as! EditableSliderCell
        cell.parent = parent
        
        cell.backgroundColor = DetailsConstants.Table.Cell.Color.background
        cell.detailNameLabel.textColor = DetailsConstants.Table.Cell.Color.text
        cell.detailNameLabel.font = DetailsConstants.Table.Cell.Font.titleLabel
        cell.selectionStyle = .none
        
        cell.detailNameLabel.text = title
        cell.detailNameLabel.sizeToFit()
        
        if minImage != nil {
            cell.detailValueSlider.minimumValueImage = minImage
        }
        if maxImage != nil {
            cell.detailValueSlider.maximumValueImage = maxImage
        }
        if pos != nil && pos! < values.count {
            cell.detailValueSlider.value = Float(pos!)/Float(values.count)
        }
        let value = values[pos ?? values.count/2]
        cell.detailValueSlider.setThumbnailText(value)
        cell.detailValueSlider.isEnabled = parent.editMode
        //cell.slider.isContinuous = false
        
        return cell
    }
}
