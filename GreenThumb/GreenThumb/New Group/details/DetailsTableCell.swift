//
//  DetailsTableCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/1/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailsTableCell: UITableViewCell {
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailValueLabel: UILabel!
    
    static func get(_ tableview: UITableView, _ label: String, _ detail: String, _ id: String) -> DetailsTableCell {
        tableview.register(UINib(nibName:"DetailsTableCell", bundle: nil), forCellReuseIdentifier: ReuseId.detailsTableCell)
        let cell = (tableview.dequeueReusableCell(withIdentifier: id) as? DetailsTableCell) ?? DetailsTableCell(style: .default, reuseIdentifier: id)
        cell.customize()
        cell.detailNameLabel?.text = label
        cell.detailValueLabel?.text = detail
        return cell
    }
    
    func customize() {
        backgroundColor = DetailsConstants.Table.Cell.Color.background
        detailNameLabel?.textColor = DetailsConstants.Table.Cell.Color.label
        detailNameLabel?.font = DetailsConstants.Table.Cell.Font.titleLabel
        detailTextLabel?.textColor = DetailsConstants.Table.Cell.Color.label
        detailTextLabel?.font = DetailsConstants.Table.Cell.Font.detailLabel
        //detailNameLabel?.sizeToFit()
    }
}
