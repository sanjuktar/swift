//
//  EditLocDetailWithSliderCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditLocDetailWithSliderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    var options: [String]?
    
    static func getCell(_ title: String, values: [String], pos: Int? = nil, table: UITableView, editMode: Bool = false, minImage: UIImage? = nil, maxImage: UIImage? = nil) -> EditLocDetailWithSliderCell {
        let cell = table.dequeueReusableCell(withIdentifier: "editLocDetailWithSliderCell") as! EditLocDetailWithSliderCell
        cell.titleLabel.text = title
        if minImage != nil {
            cell.slider?.minimumValueImage = minImage
        }
        if maxImage != nil {
            cell.slider?.maximumValueImage = maxImage
        }
        if pos != nil && pos! < values.count {
            cell.slider.value = Float(pos!)/Float(values.count)
        }
        let value = values[pos ?? values.count/2]
        cell.slider.setThumbnailText(value)
        cell.slider.isEnabled = editMode
        //cell.slider.isContinuous = false
        return cell
    }
}
