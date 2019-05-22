//
//  LocationListViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locTable: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func unwindToLocationList(segue: UIStoryboardSegue) {
        if segue.source is LocationDetailsViewController {
            let source = segue.source as! LocationDetailsViewController
            if !((locations?.contains(source.location!.id))!) {
                do {
                    try Location.manager?.add(source.location!)
                } catch {
                    output?.out(.error, "Unable to add location \(source.location!.name) - \(error.localizedDescription)")
                    return
                }
            }
            else {
                do {
                    try source.location?.updatePersisted()
                } catch {
                    output?.out(.error, "Unable to update location \(source.location!.name) - \(error.localizedDescription)")
                    return
                }
            }
            locTable.reloadData()
        }
    }
    
    var output: MessageWindow?
    var locations: [UniqueId]? {
        return Location.manager?.ids
    }
    var selectedLocation: UniqueId? {
        if let indexPath = locTable.indexPathForSelectedRow {
            return locations?[indexPath.row]
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        locTable.delegate = self
        locTable.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationDetailsSegue" {
            let dest = segue.destination as! LocationDetailsViewController
            dest.editMode = false
            dest.location = Location.manager!.get((selectedLocation)!)!.clone()
        }
        else if segue.identifier == "addLocationSegue" {
            let dest = segue.destination as! LocationDetailsViewController
            dest.editMode = true
            dest.location = Location("")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? locations?.count ?? 0 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationListCell")
        cell?.textLabel?.text = Location.manager!.get(locations![indexPath.row])!.name
        return cell!
    }
}
