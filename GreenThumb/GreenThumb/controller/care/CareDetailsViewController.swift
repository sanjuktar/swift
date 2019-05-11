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
            return care?.seasonal[.water]?.timetable.count ?? 0
        case .sun(_):
            return care?.seasonal[.sun]?.timetable.count ?? 0
        case .pestControl(_):
            return care?.seasonal[.pestControl]?.timetable.count ?? 0
        case .fertilize(_):
            return care?.seasonal[.fertilize]?.timetable.count ?? 0
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
            detail = timetable(.water, s).name
        case .sun(_):
            let s = season(.sun, indexPath.row)
            text = s.description
            detail = timetable(.sun, s).name
        case .pestControl(_):
            let s = season(.pestControl, indexPath.row)
            text = s.description
            detail = timetable(.pestControl, s).name
        case .fertilize(_):
            let s = season(.fertilize, indexPath.row)
            text = s.description
            detail = timetable(.fertilize, s).name
        case .prune:
            text = PlantDetail.prune.rawValue
            detail = (care?.nonSeasonal[.prune]?.name)!
        case .repot:
            text = PlantDetail.repot.rawValue
            detail = (care?.nonSeasonal[.repot]?.name)!
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "careCell")
        cell?.textLabel?.text = text
        cell?.detailTextLabel?.text = detail
        return cell!
    }
    
    func season(_ item: PlantDetail, _ pos: Int) -> Season {
        return (care?.seasonal[item]?.seasons[pos])!
    }
    
    func timetable(_ item: PlantDetail, _ season: Season) -> Timetable {
        return (care?.seasonal[item]?.timetable[season])!
    }
}