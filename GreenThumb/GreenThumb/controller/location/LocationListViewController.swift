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
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func unwindToLocationList(segue: UIStoryboardSegue) {
        if segue.identifier == LocationDetailsViewController.returnToLocationsListSegue {
            let source = segue.source as! LocationDetailsViewController
            guard source.location != nil else {return}
            self.collection!.reloadData()
            do {
                try Location.manager?.add(source.location!)
            } catch {
                output?.output(.error, "Unable to save changes: \(error.localizedDescription)")
            }
        }
    }
    
    static var locDetailsSegue = "locListToDetailsSegue"
    static var addLocationSegue = "addLocationSegue"
    
    var locations: [UniqueId]? {
        return Location.manager?.ids
    }
    
    override func viewDidLoad() {
        collection = locCollection
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LocationListViewController.locDetailsSegue {
            let dest = segue.destination as! LocationDetailsViewController
            dest.editMode = false
            let locId = locations?[(collection?.indexPathsForSelectedItems![0].row)!]
            dest.location = Location.manager!.get(locId!)!.clone()
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
            return CollectionViewCell.get(self, "location(?)", UIImage.noImage(), indexPath)
        }
        return CollectionViewCell.get(self, loc.name, loc.image ?? UIImage.noImage(), indexPath)
    }
    
    override func itemSelected(_ indexPath: IndexPath) {
        performSegue(withIdentifier: LocationListViewController.locDetailsSegue, sender: self)
    }
}
