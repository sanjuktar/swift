//
//  PlantTypeListPopupViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantTypeListPopupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UILabel!
    
    var type: Plant.Preferences?
    var types: [UniqueId] {
        return Plant.Preferences.manager!.ids
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(types.firstIndex(of: type!.id) ?? 0, inComponent: 0, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PlantDetailsViewController.returnFromTypesList {
            type = Plant.Preferences.manager!.get(types[pickerView.selectedRow(inComponent: 0)])
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Plant.Preferences.manager!.get(types[row])?.name
    }
}
