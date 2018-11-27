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
        if segue.identifier == PlantDetailsViewController.returnToPlantListSegue {
            let source = segue.source as! PlantDetailsViewController
            guard source.plant != nil else {return}
            var newPlant = true
            for plant in plants! {
                if plant.id == source.plant?.id {
                    newPlant = false
                    break
                }
            }
            if newPlant {
                LocationsManager.current?.add(source.plant!, at: LocationsManager.locationUnknown)
            }
            plantCollection.reloadData()
            do {
                try LocationsManager.current?.commit()
            } catch {
                output?.output(.error, "Unable to save changes: \(error.localizedDescription)")
            }
        }
    }
    
    var output: Output?
    var plants: [Plant]? {
        return LocationsManager.current?.allPlants
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        plantCollection.delegate = self
        plantCollection.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlantDetailsSegue" {
            let dest = segue.destination as! PlantDetailsViewController
            dest.editMode = true
            dest.plant = Plant([:])
        }
        else if segue.identifier == "viewPlantDetailsSegue" {
            let dest = segue.destination as! PlantDetailsViewController
            let indexPath = plantCollection.indexPathsForSelectedItems![0]
            dest.editMode = false
            dest.plant = plants?[indexPath.item]
        }
    }
    
    private func location(_ indexPath: IndexPath) -> Location {
        return LocationsManager.unknownLocation
    }
}

extension PlantsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plantCollection.dequeueReusableCell(withReuseIdentifier: "plantCell", for: indexPath) as! PlantCell
        let plant = plants![indexPath.row]
        cell.nameLabel.text = plant.name
        cell.image.image = (plant.image != nil) ? plant.image : UIImage(imageLiteralResourceName: "noImage")
        return cell
    }
}
