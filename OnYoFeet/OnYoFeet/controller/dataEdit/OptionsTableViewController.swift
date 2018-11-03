//
//  OptionsTableViewController.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class OptionsTableViewController: EditValueChildViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var options: [String]?
    var selected: Int?
    var maxHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if maxHeight == nil {
            maxHeight = parent?.view.bounds.height
        }
        tableView.delegate = self
        tableView.dataSource = self
        if (options?.count)! < tableView.visibleCells.count {
            tableView.scrollToRow(at: IndexPath(row: selected!, section: 0), at: .middle, animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let height = CGFloat.minimum(maxHeight!, tableView.contentSize.height)
        tableView.frame = CGRect(origin: tableView.frame.origin, size: CGSize(width: tableView.contentSize.width, height: height))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? (options?.count)! : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsTableCell")
        cell?.textLabel?.text = options?[row]
        cell?.accessoryType = (row == selected ? .checkmark : .none)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != selected else {return}
        
        let oldSelected = selected
        selected = indexPath.row
        var cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        cell?.setHighlighted(true, animated: false)
        
        cell = tableView.cellForRow(at: IndexPath(row: oldSelected!, section: 0))
        cell?.setSelected(false, animated: true)
        cell?.setHighlighted(false, animated: false)
        cell?.accessoryType = .none
    }
}
