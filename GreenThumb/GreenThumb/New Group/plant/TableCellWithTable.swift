//
//  PlantNameCell.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantNameCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var namesTable: UITableView!
 
    var names: NameList?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Plant.NameType.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = namesTable.dequeueReusableCell(withIdentifier: "nameTableCell")
        let type = Plant.NameType.cases[indexPath.row]
        cell?.textLabel?.text = type.rawValue
        cell?.detailTextLabel?.text = names[type] ?? ""
    }
}
