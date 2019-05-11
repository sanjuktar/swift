//
//  LocDetailWithLabelCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/6/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocDetailWithLabelCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    static func getCell(_ title: String, _ detail: String, table: UITableView) -> LocDetailWithLabelCell {
        let cell = table.dequeueReusableCell(withIdentifier: "locDetailWithLabelCell") as! LocDetailWithLabelCell
        cell.titleLabel?.text = title
        cell.detailLabel?.text = detail
        return cell
    }
}
