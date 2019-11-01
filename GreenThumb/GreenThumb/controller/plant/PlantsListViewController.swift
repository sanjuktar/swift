//
//  PlantsListViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantsListViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var plantCollection: UICollectionView!
    
    @IBAction func unwindToPlantsList(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindEditPlantToList" {
            let source = segue.source as! PlantDetailsViewController
            guard source.plant != nil else {return}
            plantCollection.reloadData()
            do {
                try Plant.manager?.add(source.plant!)
            } catch {
                output?.output(.error, "Unable to save changes: \(error.localizedDescription)")
            }
        }
    }
    
    var output: Output?
    var plants: [UniqueId]? {
        return Plant.manager?.ids
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        plantCollection.delegate = self
        plantCollection.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPlantDetailsSegue" {
            let dest = segue.destination as! PlantDetailsViewController
            dest.plant = Plant.manager!.get(selectedPlant()!)?.copy
        }
        else if segue.identifier == "addNewPlantSegue" {
            let dest = segue.destination as! PlantDetailsViewController
            dest.editMode = true
            dest.plant = Plant()
        }
    }
    
    private func location(_ indexPath: IndexPath) -> UniqueId {
        return UnknownLocation.id
    }
}

extension PlantsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plantCollection.dequeueReusableCell(withReuseIdentifier: "plantListCell", for: indexPath) as! PlantListCell
        let plant: Plant = Plant.manager!.get(plants![indexPath.row])!
        cell.nameLabel.text = plant.name
        cell.image.image = (plant.image != nil) ? plant.image : UIImage(imageLiteralResourceName: "noImage")
        return cell
    }
    
    func selectedPlant() -> UniqueId? {
        return plants?[ plantCollection.indexPathsForSelectedItems![0].row]
    }
}
