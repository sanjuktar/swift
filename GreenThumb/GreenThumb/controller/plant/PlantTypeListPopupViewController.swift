//
//  PlantTypeListPopupViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantTypeListPopupViewController: IdedObjValuePickerPopover<Plant.Preferences>  {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UILabel!
    static var storyboardId: String {
        return "plantTypeListPopover"
    }
    override var storyboardId: String {
        return PlantTypeListPopupViewController.storyboardId
    }
    override var manager: IdedObjManager<Plant.Preferences> {
        return Plant.Preferences.manager!
    }
    override var picker: UIPickerView {
        return pickerView
    }
    
    static func show(_ parent: UIViewController, _ source: UIView, _ selected: Int) {
        let popup = (parent.storyboard!.instantiateViewController(withIdentifier: storyboardId) as! PlantTypeListPopupViewController)
        popup.show(parent, source, selected)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PlantDetailsViewController.returnFromTypesList {
            selected = pickerView.selectedRow(inComponent: 0)
            return
        }
    }
}
