//
//  FrequencyBySeasonCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class FrequencyBySeasonCell: UITableViewCell {
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var nTextField: UITextField!
    @IBOutlet weak var timeMultiplierTextField: UITextField!
    @IBOutlet weak var timeUnitTextField: UITextField!
    @IBOutlet weak var specificStartSwitch: UISwitch!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var specificEndSwitch: UISwitch!
    @IBOutlet weak var endDateTextField: UITextField!
    
    static func get(_ controller: ScheduleViewController, _ season: Season, _ nX: Int, _ timeX: Int, _ timeUnit: TimeUnit, startDate: Date?, endDate: Date?) -> FrequencyBySeasonCell {
        let cell = controller.table?.dequeueReusableCell(withIdentifier: ReuseId.frequencyBySeasonCell) as! FrequencyBySeasonCell
        
        cell.seasonLabel.text = season.name
        cell.seasonLabel.textColor = ColorConstants.Table.text
        cell.nTextField.text = "\(nX)"
        cell.timeMultiplierTextField.text = "\(timeX)"
        cell.timeUnitTextField.text = "\(timeUnit)"
        if startDate != nil {
            cell.specificStartSwitch.isOn = true
            cell.startDateTextField.text = startDate?.description
        }
        else {
            cell.specificStartSwitch.isOn = false
            cell.startDateTextField.isEnabled = false
        }
        if endDate != nil {
            cell.specificEndSwitch.isOn = true
            cell.endDateTextField.text = endDate?.description
        }
        else {
            cell.specificEndSwitch.isOn = false
            cell.endDateTextField.isEnabled = false
        }
        
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ColorConstants.Table.background
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
