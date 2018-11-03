//
//  TextField.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/2/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

typealias TextFieldValidation = (TextField) -> Bool

func notEmpty(_ textField :TextField) -> Bool {
    return !(textField.text?.isEmpty)!
}

class PickerViewTextField<T:Enum> : TextField, PickerViewParent {
    func setup(delegate :UITextFieldDelegate,
               bgColor :UIColor = UIColor.white,
               textColor :UIColor = UIColor.darkText) {
        self.delegate = delegate
        self.defaultBgColor = bgColor
        self.textColor = textColor
        inputView = PickerViewImpl<T>(parent: self, nComponents: T.nCategories, selectedOption: (T.cases.index(of: T.defaut)))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let p = pickerView as? PickerView else {return 0}
        return T.nCategories
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return T.cases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let p = pickerView as? PickerView else {return ""}
        return p.text(row: row, component: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let p = pickerView as? PickerView else {return}
        updateText(p.text(row: row, component: component))
    }
}

class TextField : UITextField {
    var validate :TextFieldValidation = {_ in return true}
    var defaultBgColor :UIColor?
    var defaultTextColor :UIColor?
    var isValid :Bool {
        return validate(self)
    }
    
    func setup(text :String,
               delegate :UITextFieldDelegate,
               inputView :UIView? = nil,
               validation :@escaping TextFieldValidation = {_ in return true},
               bgColor :UIColor = UIColor.white,
               textColor :UIColor = UIColor.darkText) {
        self.text = text
        self.delegate = delegate
        self.inputView = inputView
        self.validate = validation
        self.defaultBgColor = bgColor
        self.defaultTextColor = textColor
    }
    
    func setAsErrorIfInvalid() {
        if !isValid && backgroundColor != Constants.errorColor {
            setAsError()
        }
        else if isValid && backgroundColor == Constants.errorColor {
            setAsNotError()
        }
    }
    
    func setAsNotError() {
        backgroundColor = defaultBgColor
        textColor = defaultTextColor
    }
    
    func setAsError() {
        backgroundColor = Constants.errorColor
        textColor = defaultBgColor
    }
    
    func updateText(_ text :String) {
        self.text = text
        setAsErrorIfInvalid()
    }
}
