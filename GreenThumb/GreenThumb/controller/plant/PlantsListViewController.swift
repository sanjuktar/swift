//
//  PlantsListViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantsListViewController: CollectionViewController {
    @IBOutlet weak var _editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var plantCollection: CollectionView!
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editButtonPressed()
    }
    
    @IBAction func unwindToPlantsList(segue: UIStoryboardSegue) {
        if segue.identifier == PlantDetailsViewController.returnToPlantListSegue {
            let source = segue.source as! PlantDetailsViewController
            guard source.plant != nil else {return}
            collection?.reloadData()
            do {
                try Plant.manager?.add(source.plant!)
            } catch {
                output?.output(.error, "Unable to save changes: \(error.localizedDescription)")
            }
        }
    }
    
    static var segueToPlantDetails = "plantListToDetailsSegue"
    static var addNewPlantSegue = "addNewPlantSegue"
    
    var plants: [UniqueId]? {
        return Plant.manager?.ids
    }
    
    override func viewDidLoad() {
        collection = plantCollection
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PlantsListViewController.segueToPlantDetails {
            let dest = segue.destination as! PlantDetailsViewController
            dest.plant = Plant.manager!.get(selectedPlant()!)?.clone
        }
        else if segue.identifier == PlantsListViewController.addNewPlantSegue {
            let dest = segue.destination as! PlantDetailsViewController
            dest.editMode = true
            dest.plant = Plant()
        }
    }
    
    override func nItemsInSection(_ section: Int) -> Int {
        return plants?.count ?? 0
    }
    
    override func cell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let plant = Plant.manager?.get(plants![indexPath.row]) else {
            return CollectionViewCell.get(self, "unknown plant", UIImage.noImage(), indexPath, false)
        }
        return CollectionViewCell.get(self, plant.name, plant.image ?? UIImage.noImage(), indexPath, editMode)
    }
    
    override func itemSelected(_ indexPath: IndexPath) {
        if !editMode {
            performSegue(withIdentifier: PlantsListViewController.segueToPlantDetails, sender: self)
            return
        }
    }
    
    override func deleteObject(at indexPath: IndexPath) {
        let id = plants![indexPath.row]
        do {
            try Plant.manager?.remove(id)
        } catch {
            output?.out(.error, "Unable to delete \(Plant.manager?.get(id)?.name ?? id).")
        }
    }
    
    func selectedPlant() -> UniqueId? {
        return plants?[(collection?.indexPathsForSelectedItems![0].row)!]
    }
}
