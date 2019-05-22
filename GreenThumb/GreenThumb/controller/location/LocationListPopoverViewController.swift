//
//  LocationListPopoverViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocationListPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var location: Location?
    var locations: [UniqueId] {
        return Location.manager!.ids
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(locations.firstIndex(of: location!.id) ?? 0, inComponent: 0, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIButton) == backButton {
            location = Location.manager!.get(locations[pickerView.selectedRow(inComponent: 0)])
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Location.manager!.get(locations[row])?.name
    }
}
