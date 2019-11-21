//
//  DetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var tableController: DetailsTableViewController?
    var textController: TextFieldDelegate?
    var sliderController: SliderDelegate?
    var imagePicker: ImagePickerController {
        return ImagePickerController(self)
    }
    var editSaveButton: UIBarButtonItem?
    var table: UITableView?
    var log: Log?
    var output: Output?
    var editMode: Bool = false
    var keyboardHandler: UIViewController {
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textController?.reset()
    }
    
    func setEditMode(_ flag: Bool) {
        editMode = flag
        if flag {
            editSaveButton?.title = "Save"
        }
        else {
            editSaveButton?.title = "Edit"
        }
    }
    
    func objectChanged() {
    }
    
    func selectedTableRow(_ indexPath: IndexPath) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func hightlightTableRow(at indexPath: IndexPath) -> Bool {
        return false
    }
    
    func sliderValueChanged(_ slider: UISlider) {
    }
}
