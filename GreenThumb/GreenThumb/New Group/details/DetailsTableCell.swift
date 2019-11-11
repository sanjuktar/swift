//
//  DetailsTableCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/1/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailsTableCell: UITableViewCell {
    static var detailFont: UIFont {
        return UIFont(name: "detailText", size: 5) ?? UIFont.preferredFont(forTextStyle: .body)
    }
    static var labelFont: UIFont {
        return UIFont(name: "detailLabel", size: 5) ?? UIFont.preferredFont(forTextStyle: .body)
    }
    static var labelColor: UIColor {
        return .gray
    }
    static var genericHeight: CGFloat {
        return 40
    }
    
    static func get(_ tableview: UITableView, _ label: String, _ detail: String, _ id: String = "detailsTableCell") -> DetailsTableCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: id) as! DetailsTableCell
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = detail
        cell.customize()
        return cell
    }
    
    func customize() {
        textLabel?.textColor = DetailsTableCell.labelColor
        textLabel?.font = DetailsTableCell.detailFont
        detailTextLabel?.font = DetailsTableCell.detailFont
    }
}
