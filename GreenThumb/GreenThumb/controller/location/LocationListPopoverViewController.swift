//
//  LocationListPopoverViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocationListPopoverViewController: IdedObjValuePickerPopover<Location> {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    static var storyboardId: String {
        return "locationListPopover"
    }
    override var storyboardId: String {
        return LocationListPopoverViewController.storyboardId
    }
    override var manager: IdedObjManager<Location> {
        return Location.manager!
    }
    override var picker: UIPickerView {
        return pickerView
    }
    
    static func show(_ parent: UIViewController, _ source: UIView, _ selected: Int, width: Int = 300, height: Int = 200) {
        let popup = (parent.storyboard!.instantiateViewController(withIdentifier: storyboardId) as! LocationListPopoverViewController)
        popup.show(parent, source, selected, width: width, height: height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PlantDetailsViewController.returnFromLocationList {
            selected = pickerView.selectedRow(inComponent: 0)
            return
        }
    }
}
