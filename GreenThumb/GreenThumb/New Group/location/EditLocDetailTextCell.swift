//
//  EditLocDetailTextCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditLocDetailTextCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    
    static func getCell(_ title: String, _ detail: String, table: UITableView) -> EditLocDetailTextCell {
        let cell = table.dequeueReusableCell(withIdentifier: "editLocDetailTextCell") as! EditLocDetailTextCell
        cell.titleLabel?.text = title
        cell.detailTextField?.text = detail
        return cell
    }
}
