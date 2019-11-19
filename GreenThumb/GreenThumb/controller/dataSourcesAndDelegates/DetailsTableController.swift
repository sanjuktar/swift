//
//  DetailsTableController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/14/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol DetailsTableViewController: UITableViewDataSource, UITableViewDelegate {
}

class DetailsTableController<DetailType:ObjectDetail>: NSObject, DetailsTableViewController {
    var parent: DetailsViewController
    var detailsObject: DetailType.ObjectType
    
    static func create(_ object: DetailType.ObjectType, _ parent: DetailsViewController) -> DetailsTableController<DetailType> {
        let controller = DetailsTableController<DetailType>(object, parent)
        parent.table!.dataSource = controller
        parent.table!.delegate = controller
        return controller
    }
    
    private init(_ object: DetailType.ObjectType, _ parent: DetailsViewController) {
        detailsObject = object
        self.parent = parent
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailType.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailType.items(in: section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DetailType.sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detail = DetailType.item(indexPath.section, indexPath.row) else {
            return DetailsTableCell.get(tableView, "", DetailType.unknownValue, ReuseId.detailsTableCell)
        }
        return detail.cell(parent, obj: detailsObject, editMode: parent.editMode)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailType.item(indexPath.section, indexPath.row)!.cellHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
