//
//  IdedObjValuePickerPopover.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class IdedObjValuePickerPopover<T:IdedObj>: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var selected: Int = 0 {
        didSet {
            picker?.selectRow(selected, inComponent: 0, animated: false)
        }
    }
    var picker: UIPickerView? {
        fatalError("Needs override!!!!!!")
    }
    var storyboardId: String {
        fatalError("Needs override!!!!!!")
    }
    var manager: IdedObjManager<T> {
        fatalError("Needs override!!!!!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        picker!.dataSource = self
        picker!.delegate = self
        picker!.selectRow(selected, inComponent: 0, animated: false)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return manager.ids.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return manager.get(manager.ids[row])?.name
    }
    
    func show(_ parent: UIViewController, _ source: UIView, _ selected: Int = 0, width: Int = 300, height: Int = 200) {
        preferredContentSize = CGSize(width: width, height: height)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: self)
        presentationController.sourceView = source
        presentationController.sourceRect = source.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        parent.present(self, animated: true)
    }
}
