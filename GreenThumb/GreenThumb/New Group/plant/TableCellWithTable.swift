//
//  TableCellWithTable.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class TableCellWithTable: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var labels: [String] = []
    var details: [String] = []
    
    func setContents(_ contents: [String:String]) {
        labels = contents.keys.map{$0}
        for label in labels {
            details.append(contents[label]!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCellWithTable")
        cell?.textLabel?.text = labels[indexPath.row]
        cell?.detailTextLabel?.text = details[indexPath.row]
        return cell!
    }
}
