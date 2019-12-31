//
//  LocationListViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocationListViewController: CollectionViewController {
    @IBOutlet weak var locCollection: CollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var _editButton: UIBarButtonItem!
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editButtonPressed()
    }
    
    @IBAction func unwindToLocationList(segue: UIStoryboardSegue) {
        if segue.identifier == LocationDetailsViewController.returnToLocationsListSegue {
            let source = segue.source as! LocationDetailsViewController
            guard source.location != nil else {return}
            do {
                try Location.manager?.add(source.location!)
            } catch {
                output?.output(.error, "Unable to save changes: \(error.localizedDescription)")
            }
            insertItems(collection?.indexPathsForSelectedItems)
        }
    }
    
    static var locDetailsSegue = "locListToDetailsSegue"
    static var addLocationSegue = "addLocationSegue"
    
    override var emptyMessage: String {
        return "No named locations added."
    }
    override var isEmpty: Bool {
        return locations!.isEmpty
    }
    var locations: [UniqueId]? {
        return Location.manager?.knownLocations
    }
    var selectedLocation: UniqueId? {
        locations?[(collection?.indexPathsForSelectedItems![0].row)!]
    }
    
    override func viewDidLoad() {
        collection = locCollection
        log = Location.manager?.log
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LocationListViewController.locDetailsSegue {
            let dest = segue.destination as! LocationDetailsViewController
            //dest.editMode = false
            dest.location = Location.manager!.get(selectedLocation!)!.clone()
        }
        else if segue.identifier == LocationListViewController.addLocationSegue {
            let dest = segue.destination as! LocationDetailsViewController
            dest.editMode = true
            dest.location = Location("")
        }
    }
    
    override func nItemsInSection(_ section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    override func cell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let loc = Location.manager?.get(locations![indexPath.row]) else {
            return CollectionViewCell.get(self, "location(?)", UIImage.noImage(), indexPath, false)
        }
        return CollectionViewCell.get(self, loc.name, loc.image ?? UIImage.noImage(), indexPath, editMode)
    }
    
    override func itemSelected(_ indexPath: IndexPath) {
        if !editMode {
            performSegue(withIdentifier: LocationListViewController.locDetailsSegue, sender: self)
        }
    }
    
    override func deleteObject(at indexPath: IndexPath) {
        let id = locations![indexPath.row]
        do {
            try Location.manager?.remove(id)
        } catch {
            output?.out(.error, "Unable to delete \(Location.manager?.get(id)?.name ?? id).")
        }
    }
}
