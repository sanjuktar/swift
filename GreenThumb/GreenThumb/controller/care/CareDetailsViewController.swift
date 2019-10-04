//
//  CareDetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class CareDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var type: String = ""
    var care: CareInstructions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CareDetail.Sections.inTable.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch CareDetail.Sections.inTable.items[section] {
        case .water:
            return care?.schedule[.water]?.timetable.count ?? 0
        case .light:
            return care?.schedule[.light]?.timetable.count ?? 0
        case .pestControl:
            return care?.schedule[.pestControl]?.timetable.count ?? 0
        case .fertilize:
            return care?.schedule[.fertilize]?.timetable.count ?? 0
        case .prune:
            return 1
        case .repot:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var text = ""
        var detail = ""
        let careDetail = CareDetail.Sections.inTable.items[indexPath.section]
        var careType: CareType?
        switch careDetail {
        case .water:
            careType = .water
        case .light:
            careType = .light
        case .pestControl:
            careType = .pestControl
        case .fertilize:
            careType = .fertilize
        case .prune:
            careType = .prune
        default:
            break
        }
        if careType != nil {
            let saison = season(careType!, indexPath.row)
            text = (Season.manager?.get(saison)?.description)!
            detail = careDetail.data(care!, saison)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "careCell")
        cell?.textLabel?.text = text
        cell?.detailTextLabel?.text = detail
        return cell!
    }
    
    func season(_ item: CareType, _ pos: Int) -> UniqueId {
        return (care?.schedule[item]?.seasons[pos])!
    }
    
    func timetable(_ item: CareType, _ season: UniqueId) -> Timetable {
        return (care?.schedule[item]?.timetable[season])!
    }
}
