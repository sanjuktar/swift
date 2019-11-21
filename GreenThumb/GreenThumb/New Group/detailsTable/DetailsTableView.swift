//
//  DetailsTableView.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/20/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailsTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ColorConstants.Table.background
        separatorStyle = .none
    }
}
