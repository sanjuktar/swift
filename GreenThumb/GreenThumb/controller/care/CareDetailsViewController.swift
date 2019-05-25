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
        case .water(_):
            return care?.schedule[.water]?.timetable.count ?? 0
        case .sun(_):
            return care?.schedule[.light]?.timetable.count ?? 0
        case .pestControl(_):
            return care?.schedule[.pestControl]?.timetable.count ?? 0
        case .fertilize(_):
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
        switch CareDetail.Sections.inTable.items[indexPath.section] {
        case .water(_):
            let s = season(.water, indexPath.row)
            text = s.description
            detail = timetable(.water, s).description
        case .sun(_):
            let s = season(.light, indexPath.row)
            text = s.description
            detail = timetable(.light, s).description
        case .pestControl(_):
            let s = season(.pestControl, indexPath.row)
            text = s.description
            detail = timetable(.pestControl, s).description
        case .fertilize(_):
            let s = season(.fertilize, indexPath.row)
            text = s.description
            detail = timetable(.fertilize, s).description
        case .prune:
            text = PlantDetail.prune.rawValue
            detail = (care?.schedule[.prune]?.current?.description)!
        /*case .repot:
            text = PlantDetail.repot.rawValue
            detail = (care?.schedule[.repot].current.description)!*/
        default:
            break
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
