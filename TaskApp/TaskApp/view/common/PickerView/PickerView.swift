//
//  PickerView.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/5/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol PickerView {
    var nComponents :Int {get}
    func text(row :Int, component :Int) -> String
}

class PickerViewImpl<T:Enum>: UIPickerView, PickerView {
    var nComponents = 1
    var parent :PickerViewParent?
    var options :[T] = T.cases
    
    convenience init(parent :PickerViewParent, row :Int) {
        self.init()
        setup(parent: parent, selectedOption: (row: row, component: 0))
    }
    
    convenience init?(parent :PickerViewParent, nComponents :Int, selectedOption :(row :Int, component :Int)) {
        self.init()
        self.nComponents = nComponents
        setup(parent: parent, selectedOption: (row: selectedOption.row, component: selectedOption.component))
    }
    
    func setup(parent :PickerViewParent, selectedOption :(row :Int, component :Int)) {
        self.selectRow(selectedOption.row, inComponent: selectedOption.component, animated: false)
        self.parent = parent
    }
    
    func text(row :Int, component :Int) -> String {
        guard component < nComponents else {return ""}
        return options[row].description
    }
}
